import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/model/user_model.dart';

class ProfilesRepository {
  Future<UserModel> get() async {

    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final ref = FirebaseDatabase.instance.ref("profiles/$id");
      final snapshot = await ref.get();

      if (snapshot.value == null) {
        return UserModel();
      } else {
        final result = (snapshot.value as Map?);
//print(result);
        return result!.keys.map((key) => UserModel(
          path: key,
          name: result[key]["name"]  ?? '',
          phone: result[key]["phone"]  ?? '',
          city: result[key]["city"] ?? '',
          aboutSelf: result[key]["aboutSelf"]?? '',
          birthDate: result[key]["birthDate"] ?? '',
          photo: result[key]["photo"]?? 'lib/assets/default.jpg',
        )).toList()[0];


      }
    } catch (e) {
    //  print(e);
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

  // Future<void> edit(UserModel user) async {
  //   try {
  //     final id = FirebaseAuth.instance.currentUser?.uid;
  //     if (id == null) return;
  //     final ref = FirebaseDatabase.instance.ref("profiles/$id");
  //     await ref.child(id).set({"name": user.name, "phone": user.phone, "city": user.city, "aboutSelf": user.aboutSelf, "birthDate": user.birthDate, "photo": user.photo});
  //   } catch (e) {
  //     //  print(e);
  //   }
  // }
}
