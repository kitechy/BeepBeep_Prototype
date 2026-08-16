import 'package:beepbeep_prototype/features/driver/model/driver_profile.dart';
import 'package:beepbeep_prototype/features/operator/view/widgets/driver_list_tile_widget.dart';
import 'package:beepbeep_prototype/features/operator/view/widgets/filter_button_widget.dart';
import 'package:flutter/material.dart';

class FleetDetailsSheet extends StatefulWidget {
  final List<DriverProfile> drivers;
  final Map<String, String> routeNames;
  final Map<String, String> driverNames;

  final void Function(DriverProfile driver)? onDriverTap;

  const FleetDetailsSheet({
    super.key,
    required this.drivers,
    this.routeNames = const {},
    this.driverNames = const {},
    this.onDriverTap,
  });

  @override
  State<FleetDetailsSheet> createState() => _FleetDetailsSheetState();
}

class _FleetDetailsSheetState extends State<FleetDetailsSheet> {
  String _selectedFilter = 'All';

  List<DriverProfile> get filteredDrivers {
    switch (_selectedFilter) {
      case 'Online':
        return widget.drivers
            .where((driver) => driver.status == 'online')
            .toList();

      case 'Offline':
        return widget.drivers
            .where((driver) => driver.status == 'offline')
            .toList();

      case 'All':
      default:
        return widget.drivers;
    }
  }

  int get onlineCount {
    return widget.drivers.where((driver) => driver.status == 'online').length;
  }

  int get offlineCount {
    return widget.drivers.where((driver) => driver.status == 'offline').length;
  }

  String? getRouteName(DriverProfile driver) {
    final routeId = driver.currentRouteId;

    if (routeId == null || routeId.isEmpty) {
      return null;
    }

    return widget.routeNames[routeId];
  }

  String? getDriverName(DriverProfile driver) {
    return widget.driverNames[driver.uid];
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.16,
      minChildSize: 0.12,
      maxChildSize: 0.82,
      snap: true,
      snapSizes: const [0.16, 0.45, 0.82],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xff181813).withOpacity(.80),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 11),

                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xff454039),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'DRIVER ROSTER',
                              style: TextStyle(
                                color: Color(0xffD9C29A),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),

                          Text(
                            '$onlineCount online',
                            style: const TextStyle(
                              color: Color(0xffE4DED3),
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(width: 8),

                          const Text(
                            '•',
                            style: TextStyle(
                              color: Color(0xff77736C),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            '$offlineCount offline',
                            style: const TextStyle(
                              color: Color(0xffE4DED3),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilterButtonWidget(
                              label: 'All',
                              selected: _selectedFilter == 'All',
                              onTap: () => _selectFilter('All'),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: FilterButtonWidget(
                              label: 'Online',
                              selected: _selectedFilter == 'Online',
                              onTap: () => _selectFilter('Online'),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: FilterButtonWidget(
                              label: 'Offline',
                              selected: _selectedFilter == 'Offline',
                              onTap: () => _selectFilter('Offline'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              if (filteredDrivers.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Text(
                        'No drivers found',
                        style: TextStyle(
                          color: Color(0xff9B958B),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final driver = filteredDrivers[index];

                    return DriverListTile(
                      driver: driver,
                      driverName: getDriverName(driver),
                      routeName: getRouteName(driver),
                      onTap: () {
                        widget.onDriverTap?.call(driver);
                      },
                    );
                  }, childCount: filteredDrivers.length),
                ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      },
    );
  }
}
