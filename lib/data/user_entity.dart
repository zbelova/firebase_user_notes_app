import 'dart:io';

import 'package:objectbox/objectbox.dart';
import 'package:flutter/material.dart';

//вызвать после создания entity
//flutter packages pub run build_runner build или flutter packages pub run build_runner build --delete-conflicting-outputs (удалит конфликтующие файлы).

@Entity()
class UserEntity {
  @Id()
  int id;
  String name;
  String phone;
  @Unique() String email;
  String password;

  //DateTime birthDate = DateTime.now();
  DateTime? birthDate;
  String city;
  String aboutSelf;
  String photo;

  UserEntity({
    this.id = 0,
    required this.name, required this.phone, required this.email, required this.password, this.city = '', this.aboutSelf = '', this.photo = 'lib/assets/default.jpg', this.birthDate
  });

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
            File(photo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}