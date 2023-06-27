import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class UserModel {
  String? name;
  String? phone;
  String email;
  String? password;

  //DateTime birthDate = DateTime.now();
  DateTime? birthDate;
  String city;
  String aboutSelf;
  File? photo;

  UserModel({this.name, this.phone = '', this.email = '', this.password, this.city = '', this.aboutSelf = '', this.photo, this.birthDate});

//TODO: загрузка юзера из фаербейза
  // UserModel.fromFirebase(User currentUser) {
  //   email = currentUser.email!;
  //   name = currentUser.displayName!;
  //   photo = File(currentUser.photoURL!);
  //   phone = currentUser.phoneNumber!;
  //   birthDate = currentUser.metadata.
  //   //initialize all fields from firebase
  //
  // }

  String birthDateToString() {
    return DateFormat('dd.MM.yyyy').format(birthDate!);
  }

  Widget buildPhotoImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xff03ecd4), width: 5),
        //color: Colors.lightBlueAccent
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: AspectRatio(
          aspectRatio: 1,
          child: photo == 'lib/assets/default.jpg' ? Image.asset('lib/assets/default.jpg') : Image.file(
            photo!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}