import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserModel {
  final String name;
  final String phone;
  String email;
  //final String password;
  //final String passwordOld;
  final String birthDate;
  final String city;
  final String aboutSelf;
  final String photo;
  final String? path;

  UserModel({this.name = '',
    this.phone = '',
    this.email = '',
    //this.password = '',
    //this.passwordOld = '',
    this.city = '',
    this.aboutSelf = '',
    this.photo = 'lib/assets/default.jpg',
    this.birthDate = '',
    this.path});

  UserModel.fromDB({
    this.name = '',
    this.phone = '',
    //this.password = '',
    this.city = '',
    this.aboutSelf = '',
    this.photo = 'lib/assets/default.jpg',
    this.birthDate = '',
    this.path,
    this.email = '',
    //this.passwordOld = '',
  });

  Widget buildPhotoImage() {
    // print('buildPhotoImage');
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
          child: photo == 'lib/assets/default.jpg'
              ? Image.asset('lib/assets/default.jpg')
              : FadeInImage.assetNetwork(
            placeholder: 'lib/assets/default.jpg',
            image: photo,
            fit: BoxFit.cover,
          ),
          // Image.network(
          //         photo,
          //         fit: BoxFit.cover,
          //         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          //           if (loadingProgress == null) return child;
          //           return Center(
          //             child: CircularProgressIndicator(
          //               value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          //             ),
          //           );
          //         },
          //       ),
        ),
      ),
    );
  }
}
