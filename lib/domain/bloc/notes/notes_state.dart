
// Базовое состояние экрана
import '../../model/note_model.dart';

sealed class NotesState {
  const NotesState();
}

// Начальное состояние экрана
class LoadingNotesState extends NotesState {
  const LoadingNotesState();
}

// Состояние экрана с уже загруженными данными
class LoadedNotesState extends NotesState {
  final List<NoteModel> notes;

  const LoadedNotesState({ required this.notes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoadedNotesState && runtimeType == other.runtimeType && notes == other.notes;

  @override
  int get hashCode => notes.hashCode;
}

class NotesErrorState extends NotesState {}
