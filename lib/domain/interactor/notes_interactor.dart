
import '../model/note_model.dart';

abstract class NotesInteractor {
  Future<void> write(String note);

  Stream<List<NoteModel>> readAll();

  Future<void> edit(String note, String path);

  Future<void> remove(String path);
}