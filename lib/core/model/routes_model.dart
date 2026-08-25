import 'dart:ui';

class RoutesModel {
  final String id;
  final String name;
  final Color color;
  final String encodedPolyline;

  
  RoutesModel({
    required this.id,
    required this.name,
    required this.color,
    required this.encodedPolyline,
  });

  factory RoutesModel.fromMap(String id, Map<String, dynamic> map) {
    return RoutesModel(
      id: id,
      name: map['name'],
      color: Color(int.parse(map['color'].replaceFirst('#', '0xff'))),
      encodedPolyline: map['encodedPolyline'],
    );
  }
}
