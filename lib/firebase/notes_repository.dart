import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_user_notes/model/note_model.dart';

class NotesRepository {
  Future<void> write(String note) async {
    // Берём id пользователя, чтобы у каждого пользователя была своя ветка
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    // Берём ссылку на корень дерева с записями для текущего пользователя
    final ref = FirebaseDatabase.instance.ref("notes/$id");
    // Сначала генерируем новую ветку с помощью push() и потом в эту же ветку
    // добавляем запись
    await ref.push().set(note);
  }

  //TODO: сделать чтение, редактирование и удаление записей из базы
  Stream<List<NoteModel>> readAll() {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      final ref = FirebaseDatabase.instance.ref("notes/$id");
      return ref.onValue.map((event) {
        final snapshot = event.snapshot.value as Map?;
        if (snapshot == null) {
          return [];
        }
        return snapshot.keys
            .map(
              (key) => NoteModel(path: key, note: snapshot[key] as String),
            )
            .toList();
      });
    } catch (e) {
      //print(e);
      return const Stream.empty();
    }
  }

  Future<void> edit(String note, String key) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("notes/$id");
      await ref.child(key).set(note);
    } catch (e) {
      //print(e);
    }
  }

  Future<void> remove(String key) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid;
      if (id == null) return;
      final ref = FirebaseDatabase.instance.ref("notes/$id");
      await ref.child(key).remove();
    } catch (e) {
      //print(e);
    }
  }
}
