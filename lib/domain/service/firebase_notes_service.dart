import 'package:firebase_user_notes/data/repositories/notes_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_user_notes/domain/service/notes_service.dart';
import '../model/note_model.dart';

@LazySingleton(as: NotesService)
class FirebaseNotesService implements NotesService {
  final NotesRepository _notesRepository = NotesRepository();

  @override
  Future<void> write(String note) async {
    await _notesRepository.write(note);
  }

  @override
  Future<Stream<List<NoteModel>>> readAll() async {
    return await _notesRepository.readAll();
  }

  @override
  Future<void> edit(String note, String key) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<void> remove(String key) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
