import 'package:beepbeep_prototype/core/model/user_model.dart';
import 'package:beepbeep_prototype/core/repository/routes_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/operator/view/widgets/info_row_widget.dart';
import 'package:flutter/material.dart';

class DriverDetailsSheet extends StatefulWidget {
  final DriverProfile driver;

  const DriverDetailsSheet({super.key, required this.driver});

  @override
  State<DriverDetailsSheet> createState() => _DriverDetailsSheetState();
}

class _DriverDetailsSheetState extends State<DriverDetailsSheet> {
  UserModel? _user;
  bool _isLoading = true;
  String _routeName = "No route selected";
  bool _isLoadingRoute = true;

  final UserRepository _userRepository = UserRepository(UserService());
  final RoutesRepository _routesRepo = RoutesRepository(RoutesService());

  @override
  void initState() {
    super.initState();
    _loadDriverUser();
    _loadRouteName();
  }

  Future<void> _loadDriverUser() async {
    final user = await _userRepository.getUserByUid(widget.driver.uid);

    if (!mounted) return;

    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _loadRouteName() async {
    final routeId = widget.driver.currentRouteId;

    if (routeId == null || routeId.isEmpty) {
      if (mounted) {
        setState(() {
          _routeName = "No route selected";
          _isLoadingRoute = false;
        });
      }
      return;
    }

    try {
      final route = await _routesRepo.getRoute(routeId);

      if (!mounted) return;

      setState(() {
        _routeName = route.name;
        _isLoadingRoute = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _routeName = "Unknown route";
        _isLoadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;
    final bool isOnline = driver.status == 'online';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xffF8F7F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          // Driver header
          Row(
            children: [
              _buildDriverPhoto(),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLoading ? 'Loading...' : _user?.name ?? 'Driver',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1C1A17),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Driver ID: ${driver.uid}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff77736C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xffE4F4EC)
                      : const Color(0xffF1E5E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? const Color(0xff2E7D5B) : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOnline ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOnline ? const Color(0xff2E7D5B) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: driver.phoneNumber,
          ),

          const SizedBox(height: 14),

          InfoRow(
            icon: Icons.badge_outlined,
            label: 'Plate Number',
            value: driver.licenseNumber,
          ),

          const SizedBox(height: 14),

          InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: driver.address,
          ),

          const SizedBox(height: 14),

          InfoRow(
            icon: Icons.route_outlined,
            label: 'Current Route',
            value: _isLoadingRoute ? "Loading route..." : _routeName,
          ),

          const SizedBox(height: 14),

          InfoRow(
            icon: Icons.people_outline,
            label: 'Passengers Today',
            value: '${driver.totalPassengerCount}',
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0056FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverPhoto() {
    final photoUrl = _user?.photoURL;

    if (photoUrl == null || photoUrl.isEmpty) {
      return Container(
        width: 58,
        height: 58,
        decoration: const BoxDecoration(
          color: Color(0xffE8E6E1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 32, color: Color(0xff77736C)),
      );
    }

    return CircleAvatar(
      radius: 29,
      backgroundColor: const Color(0xffE8E6E1),
      backgroundImage: NetworkImage(photoUrl),
    );
  }
}
