import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/model/user_model.dart';



class ProfilesRepository {
  Future<UserModel> get() async {

    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");
      final profileSnapshot = await ref.get();
      if (profileSnapshot.value == null) {
        return UserModel();
      } else {
        return UserModel(
          path: profileSnapshot.key,
          name: (profileSnapshot.value as Map<String, dynamic>)["name"]  ?? '',
          phone: (profileSnapshot.value as Map<String, dynamic>)["phone"]  ?? '',
          city: (profileSnapshot.value as Map<String, dynamic>)["city"] ?? '',
          aboutSelf: (profileSnapshot.value as Map<String, dynamic>)["aboutSelf"]?? '',
          birthDate: (profileSnapshot.value as Map<String, dynamic>)["birthDate"] ?? '',
          photo: (profileSnapshot.value as Map<String, dynamic>)["photo"]?? 'lib/assets/default.jpg',
        );
      }
    } catch (e) {
      print(e);
      return UserModel();
    }
  }

  // Stream<UserModel> read() {
  //   try {
  //     final id = FirebaseAuth.instance.currentUser?.uid;
  //     final ref = FirebaseDatabase.instance.ref("profiles/$id");
  //     return ref.onValue.map((event) {
  //       final snapshot = event.snapshot.value as Map?;
  //       if (snapshot == null) {
  //         return UserModel();
  //       }
  //
  //       return snapshot.keys
  //           .map(
  //             (key) => UserModel(
  //               path: key,
  //               name: snapshot[key]["name"],
  //               phone: snapshot[key]["phone"],
  //               city: snapshot[key]["city"],
  //               aboutSelf: snapshot[key]["aboutSelf"],
  //               birthDate: snapshot[key]["birthDate"],
  //               photo: snapshot[key]["photo"] ?? 'lib/assets/default.jpg',
  //             ),
  //           )
  //           .toList()
  //           .first;
  //     });
  //   } catch (e) {
  //     //print(e);
  //     return const Stream.empty();
  //   }
  // }

  Future<void> edit(UserModel user) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");
      await ref.child(id).set({"name": user.name, "phone": user.phone, "city": user.city, "aboutSelf": user.aboutSelf, "birthDate": user.birthDate, "photo": user.photo});
    } catch (e) {
      //  print(e);
    }
  }
}
