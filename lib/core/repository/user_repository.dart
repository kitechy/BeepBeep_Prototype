import 'package:beepbeep_prototype/core/model/user_model.dart';

import '../service/user_service.dart';

class UserRepository {

  // connection to the user service
  final UserService _service;
  UserRepository(this._service);

  // gets current user info from firebase auth
  Future<UserModel?> getCurrentUser() {
    return _service.getCurrentUser();
  }

  // updates user profile completed status in database
  Future<void> setProfileCompleted(String uid, bool value) {
    return _service.setProfileCompleted(uid, value);
  }

  // gets user info from database using uid
  Future<UserModel?> getUserByUid(String uid) {
    return _service.getUserByUid(uid);
  }

  // saves user role in database
  Future<void> saveRole(String role) async {
    await _service.saveRole(role);
  }
}
