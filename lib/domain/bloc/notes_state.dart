
// Базовое состояние экрана
import '../model/note_model.dart';

class NotesState {
  const NotesState();
}

// Начальное состояние экрана
class InitialNotesState extends NotesState {
  const InitialNotesState();
}

// Состояние экрана с уже загруженными данными
class LoadedNotesState extends NotesState {
  final List<NoteModel> notes;

  const LoadedNotesState(this.notes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoadedNotesState && runtimeType == other.runtimeType && notes == other.notes;

  @override
  int get hashCode => notes.hashCode;
}
