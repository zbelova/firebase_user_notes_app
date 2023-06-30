
import 'package:flutter/material.dart';
import 'package:firebase_user_notes/firebase/auth_repository.dart';
import 'package:firebase_user_notes/screens/login_page.dart';
import 'package:firebase_user_notes/screens/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/user_preferences.dart';
import 'model/users_repo.dart';
import 'globals/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late ObjectBox objectbox;


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final AuthRepository authRepository = AuthRepository();
  // final NotesRepository notesRepository = NotesRepository();
  objectbox = await ObjectBox.create();
  await UserPreferences().init();
  runApp(RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  RegistrationApp({super.key});

  final bool goToMainPage = UserPreferences().getRememberLoggedIn();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("lib/assets/bg1.jpg"), context);
    precacheImage(const AssetImage("lib/assets/bg2.jpg"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Регистрация пользователя',
      theme: SpaceTheme,
      localizationsDelegates: const [
        //локализация нужна, чтобы в виджете календаря в поле дата рождения был русифицированный календарь
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ru'),
      home: buildHomePage(),
    );
  }

  Widget buildHomePage() {
    if (goToMainPage) {
      UserPreferences().setLoggedIn(true);
      return ProfilePage();
    } else {

      return LoginPage(authRepository: AuthRepository(),);
    }
  }
}
