import 'dart:io';
import 'package:flutter/cupertino.dart';


class UserModel {
  String name;
  String phone;
  String email;
  String password;
  String birthDate;
  String city;
  String aboutSelf;
  File? photo;
  String? path;

  UserModel({this.name = '', this.phone = '', this.email = '', this.password = '', this.city = '', this.aboutSelf = '', this.photo, this.birthDate = '', this.path});

  UserModel.fromDB({
    this.name = '',
    this.phone = '',
    this.password = '',
    this.city = '',
    this.aboutSelf = '',
    this.photo,
    this.birthDate= '',
    this.path,
    this.email = '',
  });


  // String birthDateToString() {
  //   return birthDate;
  //   //return DateFormat('dd.MM.yyyy').format(birthDate!);
  // }

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
          child: Image.asset('lib/assets/default.jpg')
          // photo == 'lib/assets/default.jpg'
          //     ? Image.asset('lib/assets/default.jpg')
          //     : Image.file(
          //         photo!,
          //         fit: BoxFit.cover,
          //       ),
        ),
      ),
    );
  }
}

