import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../di/config.dart';
import '../domain/bloc/edit_profile_bloc.dart';
import '../domain/interactor/user_interactor.dart';
import '../domain/model/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../globals/widgets/display_widgets.dart';
import '../globals/widgets/form_widgets.dart';

class EditProfilePage extends StatefulWidget {
  final AuthRepository authRepository;

  EditProfilePage({super.key, required this.authRepository});

  @override
  State<EditProfilePage> createState() => EditProfileScreen();
}

class EditProfileScreen extends State<EditProfilePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController oldPasswordInput = TextEditingController();

  final bool loggedIn = FirebaseAuth.instance.currentUser != null ? true : false;

  final _cubit = getIt<EditProfileCubit>();
  final UserInteractor _interactor = getIt<UserInteractor>();

  var color;
  XFile? image;
  UploadTask? uploadTask;
  final _approve = false;
  final ImagePicker picker = ImagePicker();

  UserModel _user = UserModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateInput.dispose();
    oldPasswordInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: _content(),
    );
  }

  Widget _content() {
    if (loggedIn) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
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
              return _buildPortraitEditProfile();
            } else {
              return _buildLandscapeEditProfile();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitEditProfile() {
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
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    //print('_buildForm');
    return Form(
        key: _formkey,
        child: ListView(
          children: [buildFormColumn()],
        ));
  }

  Widget buildFormColumn() {
    //print('buildFormColumn');
    return Column(
      children: [
        if (loggedIn) buildPhotoField(),
        Container(
          child: _buildTextFieldsColumn(),
        ),
      ],
    );
  }

  Widget _buildLandscapeEditProfile() {
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
                        child: _buildTextFieldsColumn(),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      );
    });
  }

  Widget _buildTextFieldsColumn() {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (ctx, state) {
        //    print('state is $state');
        if (state is LoadedEditProfileState) {
          //TODO не отображается изначальная дата рождения
          dateInput.text = state.user.birthDate;
          //_user.photo = state.user.photo;
          print('state is LoadedProfileState');
          return Column(
            children: [
              buildEmailField(state),
              const SizedBox(
                height: 14,
              ),
              if (loggedIn) _buildOldPasswordField(state),
              if (loggedIn)
                const SizedBox(
                  height: 14,
                ),
              buildPasswordField(state),
              const SizedBox(
                height: 14,
              ),
              if (loggedIn) buildAdditionalFields(state),
              if (!loggedIn) buildApproveField(),
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      loggedIn ? await _interactor.editUser(_user) : await _interactor.signUp(_user.email, _user.password);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    loggedIn ? 'Сохранить' : 'Зарегистроваться',
                    style: const TextStyle(fontSize: 16),
                  ))
            ],
          );
        } else {
          //print('state is not LoadedEditProfileState');
          // Вначале показываем виджет с загрузкой
          ctx.read<EditProfileCubit>().fetchData();
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildNameField(state) {
    return TextFormField(
      key: const ValueKey("_user.name"),
      initialValue: state.user.name,
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

  Widget buildDateTimeField(state) {
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
          //setState(() {
            dateInput.text = formattedDate; //set output date to TextField value.
          //});
        } else {}
      },
    );
  }

  Widget buildCityField(state) {
    return TextFormField(
      key: const ValueKey("_user.city"),
      initialValue: state.user.city,
      decoration: const InputDecoration(prefixIcon: PrefixWidget('Город')),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _user.city = value!;
      },
    );
  }

  Widget buildAboutField(state) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        key: const ValueKey("_user.aboutSelf"),
        initialValue: state.user.aboutSelf,
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
    //print('buildPhotoField');

   return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (ctx, state) {
           // print('state is $state');
        if (state is LoadedEditProfileState) {
          //print('state is LoadedProfileState');
          return Column(
            children: [
              if (image != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 150,
                    child: PhotoImage(photoFile: image),
                  ),
                ),
              ] else ...[
                if (state.user.photo.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 150,
                      child: PhotoImage(photoURL: state.user.photo),
                    ),
                  ),
                ] else
                  const Text(
                    "Не выбрано",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
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
        } else {
          //print('state is not LoadedEditProfileState');
          // Вначале показываем виджет с загрузкой
          //TODO: сделать так, чтобы не было видно, что происходит загрузка
          ctx.read<EditProfileCubit>().fetchData();
          return const Center(child: CircularProgressIndicator());
        }
      },
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

  Widget buildAdditionalFields(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNameField(state),
        const SizedBox(
          height: 14,
        ),
        buildContactField(state),
        const SizedBox(
          height: 14,
        ),
        const SizedBox(
          height: 14,
        ),
        buildDateTimeField(state),
        const SizedBox(
          height: 14,
        ),
        buildCityField(state),
        const SizedBox(
          height: 14,
        ),
        buildAboutField(state),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  Widget buildEmailField(state) {
    return loggedIn
        ? ProfileTextFieldView('Аккаунт', state.user.email)
        : TextFormField(
            key: const ValueKey('_user.email'),
            initialValue: state.user.email,
            decoration: const InputDecoration(prefixIcon: PrefixWidget('Email')),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            onSaved: (value) {
              _user.email = value!;
            },
          );
  }

  Widget buildContactField(state) {
    return TextFormField(
      key: const ValueKey('_user.phone'),
      initialValue: state.user.phone.isEmpty ? "+7" : state.user.phone,
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

  Widget buildPasswordField(state) {
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
          _user.password = state.user.password;
        } else if (value!.isNotEmpty) {
          _user.password = value;
        }
      },
    );
  }

  Widget _buildOldPasswordField(state) {
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
    //uploadImageToFirebase(img!, state);

    setState(() {
      image = img;
      _user.photoFile = image;
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
