import 'package:firebase_user_notes/domain/service/firebase_user_service.dart';
import 'package:firebase_user_notes/domain/service/user_service.dart';
import 'package:injectable/injectable.dart';

import '../../domain/interactor/user_interactor.dart';
import '../../domain/model/user_model.dart';

@Injectable(as: UserInteractor)
class DefaultUserInteractor implements UserInteractor {
  //final UserService _userService = FirebaseUserService();
  final UserService _service;

  DefaultUserInteractor(this._service);

  @override
  Future<String> login(String email, String password) async {
    return await _service.login(email, password);
  }

  @override
  Future<String> signUp(String email, String password) async {
    return await _service.signUp(email, password);
  }

  @override
  Future<bool> changePassword(String email, String currentPassword, String newPassword) async {
    return await _service.changePassword(email, currentPassword, newPassword);
  }

  @override
  Future<void> logout() async {
    await _service.logout();
  }

  @override
  Future<UserModel> loadUser() async {
    return await _service.loadUser();
  }

  @override
  Future<void> editUser(UserModel user) async {
    await _service.editUser(user);
  }

  @override
  Future<bool> isLogged() async {
    return await _service.isLogged();
  }
}
