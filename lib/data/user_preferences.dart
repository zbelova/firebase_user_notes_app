import 'package:shared_preferences/shared_preferences.dart';


class UserPreferences {
  //создание переменной для сохранения preferences
  static SharedPreferences? _preferences;

  //ключ для текстового поля

  final _keyLoggedIn = 'loggedIn';
  final bool _loggedInDefault = false;
  final _keyRememberLoggedIn = 'rememberLoggedIn';
  final _keyLoggedInUserId = 'userId';
  final _keyLoggedInUserAccessToken = 'accessToken';

  //инициализация preferences
  Future init() async => _preferences = await SharedPreferences.getInstance();

  //функция очистки сохраненных данных пользователя - вызывать если надо сбросить данные
  Future clear() async => _preferences?.clear();

  //сохраняем флажок, что пользователь авторизован
  Future setLoggedIn(bool complete) async => await _preferences?.setBool(_keyLoggedIn, complete);

  bool getLoggedIn() => _preferences?.getBool(_keyLoggedIn) ?? _loggedInDefault;

  Future setRememberLoggedIn(bool flag) async => await _preferences?.setBool(_keyRememberLoggedIn, flag);

  bool getRememberLoggedIn() => _preferences?.getBool(_keyRememberLoggedIn) ?? false;

  Future setLoggedInUserId(int id) async {
    await _preferences?.setInt(_keyLoggedInUserId, id);
  }
  Future setUserAccessToken(String id) async {
    await _preferences?.setString(_keyLoggedInUserAccessToken, id);
  }

  int getLoggedInUserId() => _preferences?.getInt(_keyLoggedInUserId) ?? 0;
}
