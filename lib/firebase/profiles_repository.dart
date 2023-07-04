import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/user_model.dart';

class ProfilesRepository {
  Stream<UserModel> read() {
    //print("read");
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
                photo: snapshot[key]["photo"] ?? 'lib/assets/default.jpg',
              ),
            )
            .toList()
            .first;
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
//print("edit");
      await ref.child(id).set({"name": user.name, "phone": user.phone, "city": user.city, "aboutSelf": user.aboutSelf, "birthDate": user.birthDate, "photo": user.photo});
    } catch (e) {
      print(e);
    }
  }
}
