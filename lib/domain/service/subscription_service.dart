abstract class NotesService {
  Future<void> write(String note);

  Stream<List<NoteModel>> readAll();

  Future<void> edit(String note, String key);

  Future<void> remove(String key);
}
