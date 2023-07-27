
import '../../model/note_model.dart';

class NotesEvent {
  const NotesEvent();
}

class LoadNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final NoteModel note;

  const AddNoteEvent({required this.note});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddNoteEvent && runtimeType == other.runtimeType && note == other.note;

  @override
  int get hashCode => note.hashCode;
}

class EditNoteEvent extends NotesEvent {
  final NoteModel note;

  const EditNoteEvent({required this.note});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EditNoteEvent && runtimeType == other.runtimeType && note == other.note;

  @override
  int get hashCode => note.hashCode;
}

class DeleteNoteEvent extends NotesEvent {
  final String path;

  DeleteNoteEvent({required this.path});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DeleteNoteEvent && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}