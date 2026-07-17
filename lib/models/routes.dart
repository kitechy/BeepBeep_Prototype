import 'dart:ui';

class Routes {
  final String id;
  final String name;
  final Color color;
  final String encodedPolyline;

  Routes({
    required this.id,
    required this.name,
    required this.color,
    required this.encodedPolyline,
  });

  factory Routes.fromMap(String id, Map<String, dynamic> map) {
    return Routes(
      id: id,
      name: map['name'],
      color: Color(int.parse(map['color'].replaceFirst('#', '0xff'))),
      encodedPolyline: map['encodedPolyline'],
    );
  }
}
