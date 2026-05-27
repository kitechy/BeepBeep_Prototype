import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapTypeController {
  ValueNotifier<MapType> mapTypeNotifier = ValueNotifier(MapType.normal);

  Future<void> saveMapType(MapType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mapType', type.name);
  }

  Future<void> loadMapType() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedType = prefs.getString('mapType');

    switch (savedType) {
      case 'terrain':
        mapTypeNotifier.value = MapType.terrain;
        break;

      case 'satellite':
        mapTypeNotifier.value = MapType.satellite;
        break;

      default:
        mapTypeNotifier.value = MapType.normal;
    }
  }

  Future<void> changeMapType(MapType type) async {
    mapTypeNotifier.value = type;
    await saveMapType(type);
  }

  void closeSheet(context) {
    Navigator.pop(context);
  }

  void dispose() {
    mapTypeNotifier.dispose();
  }
}
