
import 'package:flutter/material.dart';
import 'package:firebase_user_notes/model/user_entity.dart';
import 'package:firebase_user_notes/firebase/auth_repository.dart';
import 'package:firebase_user_notes/screens/profile_page.dart';

import '../model/user_preferences.dart';

import '../main.dart';
import '../widgets/form_widgets.dart';
import 'edit_profile_page.dart';

class LoginPage extends StatefulWidget {
  final AuthRepository authRepository;

  const LoginPage({super.key, required this.authRepository});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? correctName;
  String? correctPassword;
  UserEntity? user;
  bool? _remember;

  Future<String> _login(email, password) async {
    return await widget.authRepository.login(email, password);
  }

  @override
  void initState() {
    super.initState();

    _remember = UserPreferences().getRememberLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLoginPage(context);
          } else {
            return _buildLandscapeLoginPage(context);
          }
        },
      ),
    );
  }

  Widget _buildPortraitLoginPage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/assets/bg1.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Вход в приложение',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildEmailField(),
                      const SizedBox(
                        height: 14,
                      ),
                      biuldPasswordField(),
                      const SizedBox(
                        height: 10,
                      ),
                      buildRememberField(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //backgroundColor: const Color(0xFF7821E3),
                            backgroundColor: const Color(0xFF2160E3),
                          ),
                          onPressed: _validateLogin,
                          child: const Text('Войти', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Color(0xFFE3003D),
                          // ),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => EditProfilePage(authRepository: AuthRepository(),)),
                            );
                          },
                          child: const Text('Пройти регистрацию', style: TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLoginPage(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'lib/assets/bg1.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 80,
                  top: constraints.maxHeight / 5,
                  right: 80,
                ),
                child: Form(
                    key: formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Вход в приложение',
                                style: constraints.maxWidth < 900 ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.displayLarge,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              buildEmailField(),
                              const SizedBox(
                                height: 14,
                              ),
                              biuldPasswordField(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildRememberField(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: constraints.maxWidth / 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                //  Spacer(),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      //backgroundColor: const Color(0xFF7821E3),
                                      backgroundColor: const Color(0xFF2160E3),
                                    ),
                                    onPressed: _validateLogin,
                                    child: const Text(
                                      'Войти',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    // style: ElevatedButton.styleFrom(
                                    //   backgroundColor: Color(0xFFE3003D),
                                    // ),
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => EditProfilePage(authRepository: AuthRepository(),)),
                                      );
                                    },
                                    child: const Text(
                                      'Пройти регистрацию',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                // Spacer()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ));
    });
  }

  Widget buildEmailField() {
    return TextFormField(
        decoration: const InputDecoration(
          //labelText: prefix,
          //prefixText: prefix + ':   ',
          prefixIcon: PrefixWidget('Email'),
        ),

        //style: Theme.of(context).textTheme.titleMedium,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Введите ваш email';
          }
          return null;
        },
        onChanged: (name) => setState(() => this.email = name));
    // return buildTextFormField(
    //   'Email',
    //   (value) {
    //     if (value!.isEmpty) {
    //       return 'Введите ваш email';
    //     }
    //     return null;
    //   },
    // );
  }

  Widget biuldPasswordField() {
    return TextFormField(
        decoration: const InputDecoration(

          prefixIcon: PrefixWidget('Пароль'),
        ),

        validator: (value) {
          if (value!.isEmpty) {
            return 'Введите пароль для входа';
          }
        },
        onChanged: (password) => setState(() => this.password = password));
  }

  Widget buildRememberField() {
    return SizedBox(
      width: 220,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        child: CheckboxListTile(
            title: Text(
              'Запомнить пароль',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
                fontSize: 18,
              ),
            ),
            value: _remember,
            contentPadding: const EdgeInsets.all(0),
            onChanged: (bool? value) {
              setState(() => _remember = value!);
            }),
      ),
    );
  }

  Future<void> _loadUser(email) async {
    user = (await objectbox.getByEmail(email));
    setState(() {});
  }

  Future<void> _validateLogin() async {
    Color color = Colors.red;
    String text = '';
    String loginResult;

    if (formKey.currentState!.validate()) {

      loginResult = await _login(email, password);
      if (loginResult == 'Идентификация успешна') {
        text = 'Вы успешно вошли';
        color = Colors.green;
        UserPreferences().setLoggedIn(true);
        UserPreferences().setRememberLoggedIn(_remember!);
        //FirebaseAuth.instance.currentUser
        //UserPreferences().setUserAccessToken(id);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ProfilePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        text = loginResult;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
        ),
      );
    }
  }
}

