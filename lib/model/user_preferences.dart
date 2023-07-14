import 'package:shared_preferences/shared_preferences.dart';


class UserPreferences {
  //создание переменной для сохранения preferences
  static SharedPreferences? _preferences;

  final _keyRememberLoggedIn = 'rememberLoggedIn';

  final _keyLoggedInUserAccessToken = 'accessToken';

  //инициализация preferences
  Future init() async => _preferences = await SharedPreferences.getInstance();

  //функция очистки сохраненных данных пользователя - вызывать если надо сбросить данные
  Future clear() async => _preferences?.clear();

  Future setRememberLoggedIn(bool flag) async => await _preferences?.setBool(_keyRememberLoggedIn, flag);

  bool getRememberLoggedIn() => _preferences?.getBool(_keyRememberLoggedIn) ?? false;
  String? getUserAccessToken() {
    return _preferences?.getString(_keyLoggedInUserAccessToken);
  }
}
