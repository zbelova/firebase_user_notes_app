
import '../../model/note_model.dart';

class NotesEvent {
  const NotesEvent();
}

class LoadNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final String text;

  const AddNoteEvent({required this.text});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddNoteEvent && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;
}

class EditNoteEvent extends NotesEvent {
  final String text;
  final String path;

  const EditNoteEvent({required this.text, required this.path});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EditNoteEvent && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
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