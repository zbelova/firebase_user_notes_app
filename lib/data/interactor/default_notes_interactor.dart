import 'package:injectable/injectable.dart';
import '../../domain/interactor/notes_interactor.dart';
import '../../domain/model/note_model.dart';
import '../../domain/service/notes/notes_service.dart';

@Injectable(as: NotesInteractor)
class DefaultNotesInteractor implements NotesInteractor {
  final NotesService _service;

  DefaultNotesInteractor(this._service);

  @override
  Future<void> write(String note) async {
    await _service.write(note);
  }

  @override
  Stream<List<NoteModel>> readAll() {
    return _service.readAll();
  }

  @override
  Future<void> edit(String note, String key) async {
    await _service.edit(note, key);
  }

  @override
  Future<void> remove(String key) async {
    await _service.remove(key);
  }
}