import 'package:flutter/material.dart';

// Instantiate new  theme data
final ThemeData SpaceTheme = _spaceTheme();

//Define Base theme for app
ThemeData _spaceTheme() {
// We'll just overwrite whatever's already there using ThemeData.light()
  final ThemeData base = ThemeData.light();

  // Make changes to light() theme
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: const Color.fromARGB(255, 255, 153, 51),
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 223, 27, 12),
      onSecondary: Colors.white,
      background: const Color.fromARGB(255, 228, 243, 228),
      onBackground: Colors.black,
    ),
    textTheme: _spaceTextTheme(base.textTheme),
    elevatedButtonTheme: _spaceElevatedButtonTheme(base.elevatedButtonTheme),
    inputDecorationTheme: _spaceInputDecorationTheme(base.inputDecorationTheme),
    checkboxTheme: _spaceCheckboxTheme(base.checkboxTheme),
    appBarTheme: _spaceAppbarTheme(base.appBarTheme),
  );
}

// Outside of _asthaTutorialTheme function  create another function

TextTheme _spaceTextTheme(TextTheme base) => base.copyWith(
// This'll be our appbars title
      displayLarge: base.displayLarge!.copyWith(
        fontFamily: "Raleway",
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
// for widgets heading/title
      displayMedium: base.displayMedium!.copyWith(
        fontFamily: "Raleway",
        fontSize: 26,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
// for sub-widgets heading/title
      displaySmall: base.displaySmall!.copyWith(
        fontFamily: "Raleway",
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      titleMedium: const TextStyle(color: Colors.black, fontSize: 16 // <-- TextFormField input color
          ),
      titleSmall: const TextStyle(color: Colors.blue),
      bodySmall: base.bodyLarge!.copyWith(
        fontFamily: "Raleway",
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Colors.white,
        // background: Paint()
        //   ..strokeWidth = 16.0
        //   ..color = Colors.lightBlueAccent
        //   ..style = PaintingStyle.stroke
        //   ..strokeJoin = StrokeJoin.round,
      ),
// for widgets contents/paragraph
      bodyLarge: base.bodyLarge!.copyWith(fontFamily: "Raleway", fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
// for sub-widgets contents/paragraph
      bodyMedium: base.bodyMedium!.copyWith(fontFamily: "Raleway", fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
    );

ElevatedButtonThemeData _spaceElevatedButtonTheme(ElevatedButtonThemeData base) => ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          //const Color.fromARGB(255, 223, 27, 12),
          //Colors.red,
          //  const Color(0xFFFFA32F)
          const Color(0xFFFF8800),
          //const Color(0xFF7821E3),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );

InputDecorationTheme _spaceInputDecorationTheme(InputDecorationTheme base) => InputDecorationTheme(
      contentPadding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),

      labelStyle: const TextStyle(color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      // border: const OutlineInputBorder(
      //   borderSide: BorderSide(
      //     width: 20,
      //     color: Colors.white,
      //     style: BorderStyle.solid,
      //   ),
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(20),
      //   ),
      //
      // ),

      floatingLabelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        height: 0,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: Color(0xff00d30d),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: Color(0xff00d30d),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      errorStyle: TextStyle(
          fontFamily: 'Railway',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.white,
          background: Paint()
            ..strokeWidth = 17.0
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round),
    );

CheckboxThemeData _spaceCheckboxTheme(CheckboxThemeData base) => CheckboxThemeData(side: const BorderSide(color: Colors.white, width: 2), fillColor: MaterialStateProperty.all(Colors.blue));

AppBarTheme _spaceAppbarTheme(AppBarTheme base) => const AppBarTheme(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      backgroundColor: Color(0xff00b4a6),



    );
