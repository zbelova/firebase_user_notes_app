import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:firebase_user_notes/domain/service/user_service.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/profiles_repository.dart';
import '../model/user_model.dart';

@LazySingleton(as: UserService)
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
    //print(FirebaseAuth.instance.currentUser!.email!);
    user.email = FirebaseAuth.instance.currentUser!.email!;
    return user;
  }

  @override
  Future<void> editUser(UserModel user) async {
    print(user.photoFile?.name);
    try {
      // print(user.birthDate);
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");
      await ref.child(id).set({"name": user.name, "phone": user.phone, "city": user.city, "aboutSelf": user.aboutSelf, "birthDate": user.birthDate});
      if (user.photoFile != null) {
        await uploadImageToFirebase(user, ref);
      }
    } catch (e) {
      //  print(e);
    }
  }

  Future uploadImageToFirebase(UserModel user, DatabaseReference profilesRef) async {
    print(user.photoFile?.name);
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final path = 'avatars/$id/${user.photoFile?.name}';
      final file = File(user.photoFile!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      var uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
print(urlDownload);
      await profilesRef.child(id!).update({"photo": urlDownload});
    } catch (e) {
        print(e);
    }
  }
}
