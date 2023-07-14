import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_user_notes/firebase/profiles_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_user_notes/screens/profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../widgets/form_widgets.dart';

class EditProfilePage extends StatefulWidget {
  final AuthRepository authRepository;
  final ProfilesRepository profilesRepository = ProfilesRepository();

  EditProfilePage({super.key, required this.authRepository});

  @override
  State<EditProfilePage> createState() => EditProfileScreen(profilesRepository: profilesRepository);
}

class EditProfileScreen extends State<EditProfilePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController oldPasswordInput = TextEditingController();
  final ProfilesRepository profilesRepository;

  EditProfileScreen({required this.profilesRepository});

  final bool loggedIn = FirebaseAuth.instance.currentUser != null ? true : false;

  var text;
  var color;
  XFile? image;
  UploadTask? uploadTask;
  final _approve = false;
  final ImagePicker picker = ImagePicker();

  UserModel _user = UserModel();
  bool _userLoaded = false;

  @override
  void initState() {
    _initUser();

    super.initState();
  }

  Future<void> _initUser() async {

    //if (loggedIn) {
      //print('init user');
      widget.profilesRepository.read().listen((_handleDataEvent));

      //setState(() {});
    //} else {
      //_user = UserModel(email: '', password: '');
    //}
    // setState(() {});
  }

  void _handleDataEvent(UserModel user) {
    if (mounted) {
      setState(() {
        _user = user;
        dateInput.text = _user.birthDate;
        _userLoaded = true;
      });
    }
  }

  Future<void> _updateUser() async {
    await widget.profilesRepository.edit(_user);
    if (_user.password != '' && _user.passwordOld != '') {
      bool result = await widget.authRepository.changePassword(_user.email, _user.passwordOld, _user.password);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Пароль изменен"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Не удалось изменить пароль"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _signUp() async {
    Color color = Colors.green;
    String text = 'Данные профиля сохранены';
    _formkey.currentState!.save();

    String result = await widget.authRepository.signUp(_user.email, _user.password);
    if (result == 'Регистрация успешна') {
      await widget.profilesRepository.edit(UserModel(name: ''));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ProfilePage(authRepository: widget.authRepository,)),
        (Route<dynamic> route) => false,
      );
    } else {
      color = Colors.red;
    }
    text = result;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
    //}
  }

  Future uploadImageToFirebase(XFile _image) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    final path = 'avatars/$uid/${_image.name}';
    final file = File(_image.path);
    // print('uid');
    final ref = FirebaseStorage.instance.ref().child(path);
    //print('ref');
    setState(() {
      _user.photo = 'lib/assets/default.jpg';
      uploadTask = ref.putFile(file);
    });

    //print('uploadTask');
    final snapshot = await uploadTask!.whenComplete(() {});
    //print ('snapshot');
    final urlDownload = await snapshot.ref.getDownloadURL();
    //print('urlDownload');
    setState(() {
      _user.photo = urlDownload;
      //uploadTask = null;
    });
    //Navigator.pop(context);

    //TaskSnapshot storageTaskSnapshot = await reference.putFile(_image);
    //String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
    // String imageURL = "https://firebasestorage.googleapis.com/v0/b/" +
    //     storageTaskSnapshot.ref.bucket +
    //     "/o/" +
    //     storageTaskSnapshot.ref.fullPath +
    //     "?alt=media";

    // Сохраняем ссылку на аватар пользователя в Firebase Authentication
    //await auth.currentUser!.updatePhotoURL(imageURL);
    //_user.photo = imageURL;
  }

  @override
  void dispose() {
    dateInput.dispose();
    oldPasswordInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEditProfile(context);
    //return buildScaffold(context);
  }

  Widget _buildEditProfile(BuildContext context) {
    if (loggedIn) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, _user);
            return false;
          },
          child: buildScaffold(context));
    } else {
      return buildScaffold(context);
    }
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: loggedIn
              ? const Text(
                  'Редактировать профиль',
                  style: TextStyle(fontSize: 20),
                )
              : const Text('Регистрация', style: TextStyle(fontSize: 18)),
        ),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortraitEditProfile(context);
            } else {
              return _buildLandscapeEditProfile(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitEditProfile(context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/assets/bg2.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: _buildForm(context),
    );
  }

  Widget _buildForm(context) {
    //if (user!= null) {
    return Form(
        key: _formkey,
        child: ListView(
          children: [buildFormColumn(context)],
        ));
    // } else {
    //   return const CircularProgressIndicator();
    // }
  }

  Widget buildFormColumn(context) {
    //print('buildFormColumn');
    return Column(
      children: [
       if (loggedIn) buildPhotoField(),
        Container(
          child: _buildTextFieldsColumn(context),
        ),
      ],
    );
  }

  Widget _buildLandscapeEditProfile(context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/bg2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: constraints.maxWidth > 1000
            ? const EdgeInsets.only(
                left: 80,
                top: 20,
                right: 80,
              )
            : const EdgeInsets.only(
                left: 40,
                top: 20,
                right: 40,
              ),
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(children: [
              Form(
                  key: _formkey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildPhotoField(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        flex: 4,
                        child: _buildTextFieldsColumn(context),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      );
    });
  }

  Column _buildTextFieldsColumn(BuildContext context) {
    return Column(
      children: [
        buildEmailField(),
        const SizedBox(
          height: 14,
        ),
        if (loggedIn) _buildOldPasswordField(),
        if (loggedIn)
          const SizedBox(
            height: 14,
          ),
        buildPasswordField(),
        const SizedBox(
          height: 14,
        ),
        if (loggedIn) buildAdditionalFields(),
        if (!loggedIn) buildApproveField(),
        ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                _formkey.currentState!.save();
                loggedIn ? await _updateUser() : await _signUp();
              }
            },
            child: Text(
              loggedIn ? 'Сохранить' : 'Зарегистроваться',
              style: const TextStyle(fontSize: 16),
            ))
      ],
    );
  }

  Widget buildNameField() {
    return TextFormField(
      key: const ValueKey("_user.name"),
      initialValue: _user.name,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Имя')),
      keyboardType: TextInputType.text,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return 'Введитие имя';
      //   }
      //   return null;
      // },
      onSaved: (value) {
        _user.name = value!;
      },
    );
  }

  Widget buildDateTimeField() {
    return TextFormField(
      key: const ValueKey("_user.birthDate"),

      controller: dateInput,
      //editing controller of this TextField
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          //labelText: "Дата рождения" //label text of field
          prefixIcon: PrefixWidget("Дата рождения")),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          //initialDate: user!.birthDate!,
          //initialDate: user!.birthDate??DateTime.now(),
          initialDate: DateTime.now(),
          firstDate: DateTime(1940),
          //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          //_user.birthDate = pickedDate;

          String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
          _user.birthDate = formattedDate;
          setState(() {
            dateInput.text = formattedDate; //set output date to TextField value.
          });
        } else {}
      },
    );
  }

  Widget buildCityField() {
    return TextFormField(
      key: const ValueKey("_user.city"),
      initialValue: _user.city,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Город')),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _user.city = value!;
      },
    );
  }

  Widget buildAboutField() {
    return SizedBox(
      height: 80,
      child: TextFormField(
        key: const ValueKey("_user.aboutSelf"),
        initialValue: _user.aboutSelf,
        decoration: InputDecoration(
          prefixIcon: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 5, top: 15),
                child: Text(
                  "О себе:".toUpperCase(),
                  style: TextStyle(color: Colors.grey[700]),
                  //style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        onSaved: (value) {
          _user.aboutSelf = value!;
        },
      ),
    );
  }


  Widget buildPhotoField() {
    // print('buildPhotoField');
    return Column(
      children: [
        if (image != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 150,
              child: _user.buildPhotoImage(),
            ),
          ),
        ] else ...[
          if (_user.photo != 'lib/assets/default.jpg') ...[
            SizedBox(width: 150, child: _user.buildPhotoImage()),
          ] else ...[
            const Text(
              "Не выбрано",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ],
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            //backgroundColor: const Color(0xFF7821E3),
            backgroundColor: const Color(0xFF2160E3),
          ),
          onPressed: () {
            photoAlert();
          },
          child: const Text('Выбрать фото', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildApproveField() {
    return Column(
      children: [
        CheckboxFormField(
          title: 'Я даю согласие на обработку персональных данных',
          initialValue: _approve,
          validator: (value) {
            if (value == false) {
              return 'Необходимо предоставить согласие на обработку персональных данных';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildAdditionalFields() {
    return _userLoaded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildNameField(),
              const SizedBox(
                height: 14,
              ),
              buildContactField(),
              const SizedBox(
                height: 14,
              ),
              const SizedBox(
                height: 14,
              ),
              buildDateTimeField(),
              const SizedBox(
                height: 14,
              ),
              buildCityField(),
              const SizedBox(
                height: 14,
              ),
              buildAboutField(),
              const SizedBox(
                height: 14,
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildEmailField() {
    return loggedIn
        ? ProfileTextFieldView('Аккаунт', _user.email)
        : TextFormField(
            key: const ValueKey('_user.email'),
            initialValue: _user.email,
            decoration: const InputDecoration(prefixIcon: PrefixWidget('Email')),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            onSaved: (value) {
              _user.email = value!;
            },
          );
  }

  Widget buildContactField() {
    return TextFormField(
      key: const ValueKey('_user.phone'),
      initialValue: _user.phone.isEmpty ? "+7" : _user.phone,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Телефон')),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isNotEmpty && value.length != 12 && value != '+7') {
          return 'Некорректная длина номера';
        }
        return null;
      },
      onSaved: (value) {
        _user.phone = value!;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      key: const ValueKey('_user.password'),
      decoration: InputDecoration(prefixIcon: loggedIn ? PrefixWidget('Новый пароль') : PrefixWidget('Пароль')),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty && !loggedIn) {
          return "Придуймайте пароль";
          // } else if (value.isNotEmpty && loggedIn && oldPasswordInput.text != value) {
          //   return 'Пароли не совпадают';
        }
        return null;
      },
      onSaved: (value) {
        if (loggedIn && value!.isEmpty) {
          _user.password = _user.password;
        } else if (loggedIn && value!.isNotEmpty) {
          _user.password = value;
        } else if (!loggedIn && value!.isNotEmpty) {
          _user.password = value;
        }
      },
    );
  }

  Widget _buildOldPasswordField() {
    return TextFormField(
      key: const ValueKey('_user.passwordOld'),
      controller: oldPasswordInput,
      decoration: InputDecoration(prefixIcon: PrefixWidget('Старый пароль')),
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value) {
        _user.passwordOld = value!;
      },
    );
  }

//we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    uploadImageToFirebase(img!);

    setState(() {
      image = img;
      //print('img');
    });
  }

//show popup dialog
  void photoAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(builder: (context, constraints) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Text('Выберите фото'),
              content: Container(
                height: constraints.maxHeight / 3,
                //padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.image),
                          Text('Из галереи'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.camera),
                          Text('Использовать камеру'),
                        ],
                      ),
                    ),
                     //_buidProgressIndicator()
                  ],
                ),
              ),
            );
          });
        });
  }

  String? validateImageUrl(String? value) {
    String pattern = r'^https?:\/\/.*\.(jpeg|jpg|gif|png)$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) && value.isNotEmpty) {
      return 'Неверный формат ссылки';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Укажите адрес элекронной почты';
    } else if (!regex.hasMatch(value)) {
      return 'Неверный формат адреса почты';
    } else {
      return null;
    }
  }
}
