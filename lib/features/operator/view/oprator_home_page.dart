import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/map_service.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';
import 'package:beepbeep_prototype/features/operator/viewmodel/operator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OperatorHomePage extends StatelessWidget {
  const OperatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OperatorViewModel(
        AuthRepository(AuthService()),
        OperatorRepository(OperatorService()),
        MapService(),
      ),
      child: _OperatorView(),
    );
  }
}

class _OperatorView extends StatefulWidget {
  const _OperatorView();

  @override
  State<_OperatorView> createState() => __OperatorViewState();
}

class __OperatorViewState extends State<_OperatorView> {
  @override
  @override
  Widget build(BuildContext context) {
    final operatorVM = context.watch<OperatorViewModel>();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.1391, 123.7438),
            ),
            zoomControlsEnabled: false,
            onMapCreated: operatorVM.onMapCreated,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: const Color(0xffF8F7F4),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        // TODO: Open drawer/menu
                      },
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.menu_rounded,
                          size: 22,
                          color: Color(0xff1C1A17),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
