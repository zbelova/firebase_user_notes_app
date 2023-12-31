import 'package:firebase_user_notes/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import '../data/user_preferences.dart';
import '../domain/interactor/user_interactor.dart';
import '../globals/widgets/form_widgets.dart';
import '../di/config.dart';
import 'edit_profile_page.dart';

class LoginPage extends StatefulWidget {
  //final AuthRepository authRepository;

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool? _remember;
  final UserInteractor _interactor = getIt<UserInteractor>();

  // Future<String> _login(email, password) async {
  //   return await widget.authRepository.login(email, password);
  // }

  @override
  void initState() {
    super.initState();

    _remember = UserPreferences().getRememberLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortraitLoginPage(context);
            } else {
              return _buildLandscapeLoginPage(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLoginPage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/bg1.jpg',
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
                  key: _formKey,
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
                          //onPressed: _validateLogin,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _authLogin();
                              //Navigator.pop(context);
                            }
                          },
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
                               MaterialPageRoute(builder: (context) => EditProfilePage()),
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
                'assets/bg1.jpg',
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
                    key: _formKey,
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
                                    onPressed: _authLogin,
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
                                      // await Navigator.of(context).push(
                                      //   MaterialPageRoute(builder: (context) => EditProfilePage(authRepository: AuthRepository(),)),
                                      // );
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
          return null;
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



  Future<void> _authLogin() async {
    Color color = Colors.red;
    String text = '';
    String loginResult;

    if (_formKey.currentState!.validate()) {
      loginResult= await _interactor.login(email, password);
      //loginResult = await _login(email, password);
      if (loginResult == 'success') {
        text = 'Вы успешно вошли';
        color = Colors.green;
        UserPreferences().setRememberLoggedIn(_remember!);
        //FirebaseAuth.instance.currentUser
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

