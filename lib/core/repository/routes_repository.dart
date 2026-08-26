import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/core/model/routes_model.dart';

class RoutesRepository {
// variable        (_) private to this Dart file
  final RoutesService _routeService;
// constructor
  RoutesRepository(this._routeService);

// call one specific route
  Future<RoutesModel> getRoute(String routeId) async {
    return await _routeService.getRoute(routeId);
  }

// call all routes
  Future<List<RoutesModel>> getRoutes() async {
    return await _routeService.getRoutes();
  }
}
