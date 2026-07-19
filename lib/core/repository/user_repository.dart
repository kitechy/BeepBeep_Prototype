import '../service/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<void> setProfileCompleted(String uid, bool value) {
    return _service.setProfileCompleted(uid, value);
  }
}
