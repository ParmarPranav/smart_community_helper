import 'package:flutter/material.dart';
import 'package:food_hunt_admin_app/models/place.dart';
import 'package:google_maps/google_maps.dart' as gMap;
import 'dart:ui' as ui;
import 'dart:html';

class WebMapWidget extends StatefulWidget {
  final PlaceLocation initialLocation;

  WebMapWidget({
    this.initialLocation = const PlaceLocation(latitude: 37.422, longitude: -122.084),
  });

  @override
  _WebMapWidgetState createState() => _WebMapWidgetState();
}

class _WebMapWidgetState extends State<WebMapWidget> {

  gMap.LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = gMap.LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude);
  }

  void _selectLocation(gMap.LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
      ),
      body: _map(),
    );
  }

  Widget _map() {
    final String htmlId = "map";
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = gMap.MapOptions()
        ..zoom = 16.0
        ..center = gMap.LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude);

      final elem = DivElement()..id = htmlId;
      final map = gMap.GMap(elem, mapOptions);

      final _icon = gMap.Icon()
        ..scaledSize = gMap.Size(40, 40)
        ..url = "https://lh3.googleusercontent.com/ogw/ADGmqu_RzXtbUv4nHU9XjdbNtDNQ5XAIlOh_1jJNci48=s64-c-mo";

      gMap.Marker(gMap.MarkerOptions()
        ..anchorPoint = gMap.Point(0.5, 0.5)
        ..icon = _icon
        ..position = _pickedLocation
        ..map = map
        ..title = htmlId);

      map.onCenterChanged.listen((event) {
        print(map.zoom);
      });

      map.onClick.listen((event) {
        print('onClick called');
        setState(() {
          _pickedLocation = event.latLng;
        });
      });

      map.onDragstart.listen((event) {
        print('onDragstart called');
      });

      map.onDragend.listen((event) {
        print('onDragend called');
      });

      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }
}
