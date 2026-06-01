import 'package:beepbeep_prototype/features/map/viewmodel/map_type_controller.dart';
import 'package:beepbeep_prototype/features/map/view/widgets/map_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeSheet extends StatelessWidget {
  final MapTypeController mapTypeController;

  const MapTypeSheet({super.key, required this.mapTypeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ValueListenableBuilder(
          valueListenable: mapTypeController.mapTypeNotifier,
          builder: (context, mapType, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MapTypeCard(
                  onTap: () {
                    mapTypeController.changeMapType(MapType.normal);
                    mapTypeController.closeSheet(context);
                  },
                  imageUrl: "assets/images/default_map_type.png",
                  title: "Default",
                  selected: mapType == MapType.normal,
                ),
                MapTypeCard(
                  onTap: () {
                    mapTypeController.changeMapType(MapType.terrain);
                    mapTypeController.closeSheet(context);
                  },
                  imageUrl: "assets/images/default_map_type.png",
                  title: "Terrain",
                  selected: mapType == MapType.terrain,
                ),
                MapTypeCard(
                  onTap: () {
                    mapTypeController.changeMapType(MapType.satellite);
                    mapTypeController.closeSheet(context);
                  },
                  imageUrl: "assets/images/satellite_map_type.png",
                  title: "Satellite",
                  selected: mapType == MapType.satellite,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
