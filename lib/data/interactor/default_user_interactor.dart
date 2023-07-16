import 'package:firebase_user_notes/domain/service/firebase_user_service.dart';
import 'package:firebase_user_notes/domain/service/user_service.dart';

import '../../domain/interactor/user_interactor.dart';
import '../../domain/model/user_model.dart';

class DefaultUserInteractor implements UserInteractor {
  final UserService _userService = FirebaseUserService();

  @override
  Future<String> login(String email, String password) async {
    return await _userService.login(email, password);
  }

  @override
  Future<String> signUp(String email, String password) async {
    return await _userService.signUp(email, password);
  }

  @override
  Future<bool> changePassword(String email, String currentPassword, String newPassword) async {
    return await _userService.changePassword(email, currentPassword, newPassword);
  }

  @override
  Future<void> logout() async {
    await _userService.logout();
  }

  @override
  Future<UserModel> loadUser() async {
    return await _userService.loadUser();
  }
}
