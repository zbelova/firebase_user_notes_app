import 'package:image_picker/image_picker.dart';


class UserModel {
  String name;
  String phone;
  String email;
  String password;
  String passwordOld;
  String birthDate;
  String city;
  String aboutSelf;
  String photo;
  XFile? photoFile;
  final String? path;

  UserModel({this.name = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.passwordOld = '',
    this.city = '',
    this.aboutSelf = '',
    this.photo = 'lib/assets/default.jpg',
    this.birthDate = '',
    this.path});


}
