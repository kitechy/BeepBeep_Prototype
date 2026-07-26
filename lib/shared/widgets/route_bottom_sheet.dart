import 'package:beepbeep_prototype/models/routes_model.dart';
import 'package:flutter/material.dart';

class _Palette {
  static const ink = Color(0xFF1C1A17);
  static const muted = Color(0xFF8A8378);
  static const line = Color(0xFFE7E0D2);
  static const gold = Color(0xFFC7952F);

  static const tags = [
    Color(0xFF2E7D5B),
    Color(0xFFB2542D),
    Color(0xFF3D6EA8),
    Color(0xFF8A5CB0),
  ];
}

class RouteBottomSheet extends StatefulWidget {
  final List<RoutesModel> routes;
  final Future<void> Function(RoutesModel routes) onRouteSelected;
  final int Function(String routeId)? activeDriverCount;

  const RouteBottomSheet({
    super.key,
    required this.routes,
    required this.onRouteSelected,
    this.activeDriverCount,
  });

  @override
  State<RouteBottomSheet> createState() => _RouteBottomSheetState();
}

class _RouteBottomSheetState extends State<RouteBottomSheet> {
  String _query = '';
  String? _loadingRouteId;

  Color _tagColorFor(String key) =>
      _Palette.tags[key.hashCode.abs() % _Palette.tags.length];

  @override
  Widget build(BuildContext context) {
    final routes = widget.routes
        .where((r) => r.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF8F7F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE7E0D2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Select a route',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: _Palette.ink,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _Palette.line),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.search_rounded,
                      size: 19,
                      color: _Palette.muted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(
                          fontSize: 15,
                          color: _Palette.ink,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search a route',
                          hintStyle: TextStyle(
                            color: _Palette.muted,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            Flexible(
              child: routes.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'No routes match your search.',
                        style: TextStyle(color: _Palette.muted, fontSize: 14),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: routes.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: _Palette.line,
                        indent: 22,
                        endIndent: 22,
                      ),
                      itemBuilder: (context, index) {
                        final route = routes[index];
                        final activeDrivers = widget.activeDriverCount?.call(
                          route.id,
                        );
                        final tagColor = _tagColorFor(route.id.toString());
                        final isLoading = _loadingRouteId == route.id;

                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () async {
                                  setState(() => _loadingRouteId = route.id);

                                  await widget.onRouteSelected(route);

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.directions_bus_filled_rounded,
                                    size: 17,
                                    color: tagColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    route.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _Palette.ink,
                                    ),
                                  ),
                                ),
                                if (activeDrivers != null) ...[
                                  const SizedBox(width: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: activeDrivers > 0
                                          ? Colors.green.shade50
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '$activeDrivers Active',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: activeDrivers > 0
                                            ? Colors.green.shade700
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                                if (isLoading)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _Palette.gold,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 20,
                                    color: _Palette.muted,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
