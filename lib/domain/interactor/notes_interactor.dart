
import '../model/note_model.dart';

abstract class NotesInteractor {
  Future<void> write(String note);

  Future<Stream<List<NoteModel>>> readAll();

  Future<void> edit(String note, String key);

  Future<void> remove(String key);
}