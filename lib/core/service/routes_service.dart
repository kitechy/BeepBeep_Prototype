import 'package:beepbeep_prototype/core/model/routes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// reference for firestore
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RoutesService {
  
// retrieve the data based on the routeId
  Future<RoutesModel> getRoute(String routeId) async {
    final doc = await _firestore
        .collection('jeepney_routes')
        .doc(routeId)
        .get();

    return RoutesModel.fromMap(doc.id, doc.data()!);
  }

// retrieve all the routes data
  Future<List<RoutesModel>> getRoutes() async {
    final snapshot = await _firestore
        .collection('jeepney_routes')
        .get();

    return snapshot.docs
        .map((doc) => RoutesModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
