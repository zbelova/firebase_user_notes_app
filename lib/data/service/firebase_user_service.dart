import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:firebase_user_notes/data/service/user_service.dart';
import '../../model/user_model.dart';
import '../repositories/profiles_repository.dart';

class FirebaseUserService implements UserService {
  ProfilesRepository _profilesRepository = ProfilesRepository();
  AuthRepository _authRepository = AuthRepository();

  @override
  Future<String> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  @override
  Future<String> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  @override
  Future<bool> changePassword(String email, String currentPassword, String newPassword) async {
    return await _authRepository.changePassword(email, currentPassword, newPassword);
  }

  @override
  Future<void> logout() async {
    await AuthRepository.logout();
  }

  @override
  Future<UserModel> loadUser() async {
    UserModel user = await _profilesRepository.get();
    user.email = FirebaseAuth.instance.currentUser!.email!;
    return user;
  }
}