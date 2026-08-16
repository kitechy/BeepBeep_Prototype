import 'package:beepbeep_prototype/core/model/user_model.dart';

import '../service/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<UserModel?> getCurrentUser() {
    return _service.getCurrentUser();
  }

  Future<void> setProfileCompleted(String uid, bool value) {
    return _service.setProfileCompleted(uid, value);
  }

  Future<UserModel?> getUserByUid(String uid) {
    return _service.getUserByUid(uid);
  }

  Future<void> saveRole(String role) async {
    await _service.saveRole(role);
  }
}
