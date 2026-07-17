import 'package:beepbeep_prototype/models/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Routes> getRoute(String routeId) async {
    final doc = await _firestore
        .collection('jeepney_routes')
        .doc(routeId)
        .get();

    return Routes.fromMap(doc.id, doc.data()!);
  }

  Future<List<Routes>> getRoutes() async {
    final snapshot = await _firestore.collection('jeepney_routes').get();

    return snapshot.docs
        .map((doc) => Routes.fromMap(doc.id, doc.data()))
        .toList();
  }
}
