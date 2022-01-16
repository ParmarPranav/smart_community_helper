import 'dart:convert';

import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static const GOOGLE_API_KEY = "AIzaSyAAsPjbLKLxeY6DcrnCFkzcFSuz7vsH8QI";

  static String generateLocationPreviewImage({required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }

  static Future<List<dynamic>> getAddressComponentsList(double lat, double lng) async{
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    List<dynamic> address_components = json.decode(response.body)['results'][0]['address_components'];
    return address_components;
  }

  static Future<String> getAddress(List<dynamic> address_components) async {
    String address = '';
    for (int i = 0; i < address_components.length; i++) {
      List<dynamic> types = address_components[i]['types'] as List<dynamic>;
      for (int j = 0; j < types.length; j++) {
        if (types[j].toLowerCase() == "street_number") {
          address += address_components[i]['long_name'] + ' ';
        }
        if (types[j].toLowerCase() == "route") {
          address += address_components[i]['long_name'];
        }
      }
    }
    return address;
  }

  static Future<String> getCity(List<dynamic> address_components) async {
    String city = '';
    for (int i = 0; i < address_components.length; i++) {
      List<dynamic> types = address_components[i]['types'] as List<dynamic>;
      for (int j = 0; j < types.length; j++) {
        if (types[j].toLowerCase() == "locality") {
          city = address_components[i]['long_name'];
        }
      }
    }
    return city;
  }

  static Future<String> getState(List<dynamic> address_components) async {
    String state = '';
    for (int i = 0; i < address_components.length; i++) {
      List<dynamic> types = address_components[i]['types'] as List<dynamic>;
      for (int j = 0; j < types.length; j++) {
        if (types[j].toLowerCase() == "administrative_area_level_1") {
          state = address_components[i]['long_name'];
        }
      }
    }
    return state;
  }

  static Future<String> getCountry(List<dynamic> address_components) async {
    String country = '';
    for (int i = 0; i < address_components.length; i++) {
      List<dynamic> types = address_components[i]['types'] as List<dynamic>;
      for (int j = 0; j < types.length; j++) {
        if (types[j].toLowerCase() == "country") {
          country = address_components[i]['long_name'];
        }
      }
    }
    return country;
  }

  static Future<String> getZipCode(List<dynamic> address_components) async {
    String zipCode = '';
    for (int i = 0; i < address_components.length; i++) {
      List<dynamic> types = address_components[i]['types'] as List<dynamic>;
      for (int j = 0; j < types.length; j++) {
        if (types[j].toLowerCase() == "postal_code") {
          zipCode = address_components[i]['long_name'];
        }
      }
    }
    return zipCode;
  }

  static Future<List<AutocompletePrediction>?> getCityList(String input, String sessionToken) async {
    GooglePlace googlePlace = GooglePlace(LocationHelper.GOOGLE_API_KEY);
    AutocompleteResponse? response = await googlePlace.autocomplete.get(
      input,
      sessionToken: sessionToken,
      language: 'en',
      types: '(cities)',
      components: [
        Component('country', 'in'),
        Component('country', 'ca'),
      ],
    );
    print(response!.predictions);
    print('Status: ${response.status}');
    return response.predictions;
  }

  static Future getStatesList(String input, String sessionToken) async {
    GooglePlace googlePlace = GooglePlace(LocationHelper.GOOGLE_API_KEY);
    await googlePlace.autocomplete.get(
      input,
      sessionToken: sessionToken,
      language: 'en',
      types: '(cities)',
      components: [
        Component('country', 'in'),
        Component('country', 'ca'),
      ],
    );
  }
}
