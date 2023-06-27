import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AuthRepository {
  Future<String> login(String email, String password) async {
    //List<String> result = [];
    String result = "";
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print(user);
      //UserPreferences().setUserAccessToken(user.credential!.accessToken!);
      return "Идентификация успешна";
    } on FirebaseAuthException catch (e) {
      // Код ошибка для случая, если пользователь не найден
      if (e.code == 'user-not-found') {
        return "Пользователь не найден";
        // Код ошибка для случая, если пользователь ввёл неверный пароль
      } else if (e.code == 'wrong-password') {
        return "Неверный пароль";
      }
    } catch(e) {
      return "Ошибка";
    }
    return "Ошибка";

      //user.credential.accessToken; //сохранять в префс для проверки залогиненности
      //FirebaseAuth.instance.currentUser //сохранять в префс для проверки залогиненности

  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }



  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}