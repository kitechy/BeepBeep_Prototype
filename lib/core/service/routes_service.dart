import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RoutesService {
  
  Future<RoutesModel> getRoute(String routeId) async {
    final doc = await _firestore
        .collection('jeepney_routes')
        .doc(routeId)
        .get();

    return RoutesModel.fromMap(doc.id, doc.data()!);
  }

  Future<List<RoutesModel>> getRoutes() async {
    final snapshot = await _firestore.collection('jeepney_routes').get();

    return snapshot.docs
        .map((doc) => RoutesModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
