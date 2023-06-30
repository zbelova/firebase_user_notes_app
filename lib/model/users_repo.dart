import 'package:firebase_user_notes/model/user_entity.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<UserEntity> _userBox;

  ObjectBox._create(this._store) {
    _userBox = Box<UserEntity>(_store);

    // Add some demo data if the box is empty.
    if (_userBox.isEmpty()) {
      _putDemoData();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    final demoUsers = [
      UserEntity(name: 'aaa', password: '123', email: '1@c.com', phone: '+75554445544'),
      UserEntity(name: 'bbb', password: '123', email: '2@c.com', phone: '+75554445544'),
      UserEntity(name: 'ccc', password: '123', email: '3@c.com', phone: '+75554445544'),
    ];
    _userBox.putManyAsync(demoUsers);
  }


  Future<UserEntity?> getByEmail(String email) async {
    Query<UserEntity> query = _userBox.query(UserEntity_.email.equals(email)).build();
    List<UserEntity> objects = query.find();
    UserEntity? userByEmail = objects.isNotEmpty ? objects.first : null;
    query.close();
    return userByEmail;
  }

  Future<UserEntity?> getById(int id) async {
    //id = 1;
    return _userBox.getAsync(id);
  }


  Future<UserEntity> addUser({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) =>
      _userBox.putAndGetAsync(
        UserEntity(name: name, password: password, email: email, phone: phone),
      );

  Future<UserEntity> addUserObject(UserEntity user) =>
      _userBox.putAndGetAsync(
        user,
      );

  Future<void> removeUser(int id) => _userBox.removeAsync(id);

  Future<void> updateUser(UserEntity user) => _userBox.putAsync(user);
}


