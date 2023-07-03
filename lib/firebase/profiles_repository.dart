import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/user_model.dart';

class ProfilesRepository {

  Stream<UserModel> read() {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");
      return ref.onValue.map((event) {
        final snapshot = event.snapshot.value as Map?;
        if (snapshot == null) {
          return UserModel();
        }

        return snapshot.keys
            .map(
              (key) => UserModel.fromDB(
                path: key,
                name: snapshot[key]["name"],
                phone: snapshot[key]["phone"],
                city: snapshot[key]["city"],
                aboutSelf: snapshot[key]["aboutSelf"],
                birthDate: snapshot[key]["birthDate"],
              ),
            )
            .toList().first;
      });
    } catch (e) {
      //print(e);
      return const Stream.empty();
    }
  }

  Future<void> edit(UserModel user) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");

      await ref.child(id).set({"name": user.name, "phone" : user.phone, "city": user.city, "aboutSelf": user.aboutSelf, "birthDate": user.birthDate});
    } catch (e) {
      print(e);
    }
  }

  Future<void> remove(String key) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("notes/$id");
      await ref.child(key).remove();
    } catch (e) {
      //print(e);
    }
  }
}
