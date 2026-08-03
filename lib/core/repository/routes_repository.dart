import 'package:beepbeep_prototype/core/service/routes_service.dart';
import 'package:beepbeep_prototype/core/model/routes_model.dart';

class RoutesRepository {
  final RoutesService _routeService;

  RoutesRepository(this._routeService);

  Future<RoutesModel> getRoute(String routeId) async {
    return await _routeService.getRoute(routeId);
  }

  Future<List<RoutesModel>> getRoutes() async {
    return await _routeService.getRoutes();
  }
}
