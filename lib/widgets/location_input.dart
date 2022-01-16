import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/place.dart';
import 'package:food_hunt_admin_app/screens/map_screen.dart';
import 'package:food_hunt_admin_app/screens/responsive_layout.dart';
import 'package:food_hunt_admin_app/utils/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function selectLocationHandler;

  LocationInput({
    required this.selectLocationHandler,
  });

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  late String _previewUrl = '';

  PlaceLocation? _currentPlaceLocation;
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> _getUserLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    final staticMapPreviewUrl = LocationHelper.generateLocationPreviewImage(
      latitude: _locationData.latitude!,
      longitude: _locationData.longitude!,
    );
    String address = await LocationHelper.getPlaceAddress(_locationData.latitude!, _locationData.longitude!);
    setState(() {
      _previewUrl = staticMapPreviewUrl;
      _currentPlaceLocation = PlaceLocation(
        latitude: _locationData.latitude!,
        longitude: _locationData.longitude!,
        address: address,
      );
    });
    widget.selectLocationHandler(_currentPlaceLocation);
  }

  Future<void> _selectOnMap() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    final selectedLocation = await Navigator.of(context).push<LatLng?>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return MapScreen(
          initialLocation: PlaceLocation(
            latitude: _locationData.latitude!,
            longitude: _locationData.longitude!,
          ),
          isSelecting: true,
        );
      },
    ));
    if (selectedLocation == null) {
      return;
    }
    final staticMapPreviewUrl = LocationHelper.generateLocationPreviewImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    String address = await LocationHelper.getPlaceAddress(selectedLocation.latitude, selectedLocation.longitude);
    setState(() {
      _previewUrl = staticMapPreviewUrl;
      _currentPlaceLocation = PlaceLocation(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        address: address,
      );
    });
    widget.selectLocationHandler(_currentPlaceLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: ResponsiveLayout.isLargeScreen(context) ? 300 : 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: DottedDecoration(
            shape: Shape.box,
            borderRadius: BorderRadius.circular(30),

          ),
          child: _previewUrl == ''
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    _previewUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
        ),
        if (_currentPlaceLocation != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      _currentPlaceLocation!.address!,
                      textAlign: TextAlign.justify,
                      maxLines: 5,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _getUserLocation();
              },
              icon: Icon(Icons.my_location),
              label: Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: () {
                _selectOnMap();
              },
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
            )
          ],
        )
      ],
    );
  }
}
