import 'dart:math';

import 'package:flutter/material.dart';

class ProjectConstant {
  static String appName = "Food Hunt";
  static String hostUrl = "http://192.168.0.105:8080/";
  static String business_logo_url = "${hostUrl}businesslogo";
  static String cover_photo_url = "${hostUrl}coverphoto";
  static String photo_gallery_url = "${hostUrl}photogallery";
  static const GOOGLE_API_KEY = "AIzaSyB6WvHs_whX1olbnbqWOxr1XJX8W_k2Rdw";

  static String getRandomString(int length) {
    String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static TextStyle WorkSansFontRegularTextStyle({
    required double fontSize,
    required Color fontColor,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
        fontWeight: FontWeight.w400,
        color: fontColor,
        fontSize: fontSize,
        fontFamily: "Work Sans",
        decoration: decoration,
      );

  static TextStyle WorkSansFontMediumTextStyle({
    required double fontSize,
    required Color fontColor,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
        fontWeight: FontWeight.w500,
        color: fontColor,
        fontSize: fontSize,
        fontFamily: "Work Sans",
        decoration: decoration,
      );

  static TextStyle WorkSansFontSemiBoldTextStyle({
    required double fontSize,
    required Color fontColor,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
        fontWeight: FontWeight.w600,
        color: fontColor,
        fontSize: fontSize,
        fontFamily: "Work Sans",
        decoration: decoration,
      );

  static TextStyle WorkSansFontBoldTextStyle({
    required double fontSize,
    required Color fontColor,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
        fontWeight: FontWeight.w700,
        color: fontColor,
        fontSize: fontSize,
        fontFamily: "Work Sans",
        decoration: decoration,
      );
}
