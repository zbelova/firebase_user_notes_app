import 'package:flutter/material.dart';
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:firebase_user_notes/screens/login_page.dart';
import 'package:firebase_user_notes/screens/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'keys.dart';
import 'model/user_preferences.dart';
import 'globals/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserPreferences().init();
  Stripe.publishableKey = stripePubKey;
  await Stripe.instance.applySettings();
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
      return ProfilePage(authRepository: AuthRepository());
    } else {

      return LoginPage(authRepository: AuthRepository(),);
    }
  }
}
