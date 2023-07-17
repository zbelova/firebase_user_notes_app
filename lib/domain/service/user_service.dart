

import '../model/user_model.dart';

abstract class UserService {
  Future<String> login(String email, String password);

  Future<String> signUp(String email, String password);

  Future<bool> changePassword(String email, String currentPassword, String newPassword);

  Future<void> logout();

  Future<UserModel> loadUser();

  Future<void> editUser(UserModel user);
}
