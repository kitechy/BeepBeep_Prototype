import 'package:beepbeep_prototype/features/operator/model/operator_profile.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';

class OperatorRepository {
  final OperatorService _operatorService;

  OperatorRepository(this._operatorService);

  Future<String> generateCode() async {
    return _operatorService.generateUniqueCode();
  }

  Future<void> createOperatorProfile(OperatorProfile profile) async {
    await _operatorService.createOperatorProfile(profile);
  }

  Future<OperatorProfile?> getOperatorProfile(String uid) {
    return _operatorService.getOperatorProfile(uid);
  }

  Future<OperatorProfile?> getOperatorByCode(String code) {
    return _operatorService.getOperatorByCode(code);
  }
}
