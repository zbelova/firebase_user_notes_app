import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../interactor/notes_interactor.dart';
import 'notes_event.dart';
import 'notes_state.dart';

@Injectable()
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesInteractor _interactor;

  NotesBloc(this._interactor) : super(LoadingNotesState()) {
    on<LoadNotesEvent>(_onLoadEvent);
    on<AddNoteEvent>(_onAddEvent);
    on<EditNoteEvent>(_onEditEvent);
    on<DeleteNoteEvent>(_onDeleteEvent);
    add(LoadNotesEvent());
  }

  FutureOr<void> _onLoadEvent(LoadNotesEvent event, Emitter<NotesState> emit) async {
    emit(const LoadingNotesState());
    emit.forEach(_interactor.readAll(), onData: (notes) {
      return LoadedNotesState(notes: notes);
    }, onError: (error, stackTrace) {
      return NotesErrorState();
    });
  }

  FutureOr<void> _onAddEvent(AddNoteEvent event, Emitter<NotesState> emit) async {
     try {
       await _interactor.write(event.text);
     } catch (e) {
       emit(NotesErrorState());
     }
  }

  FutureOr<void> _onEditEvent (EditNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await _interactor.edit(event.note.note, event.note.path);
    } catch (e) {
      emit(NotesErrorState());
    }
  }

  FutureOr<void> _onDeleteEvent (DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await _interactor.remove(event.path);
    } catch (e) {
      emit(NotesErrorState());
    }
  }
// NotesBloc(this._interactor) : super(const LoadingNotesState()) {
//   on<LoadNotesEvent>(_onFetchData);
// }

// NotesBloc(this._interactor) : super(LoadNotesEvent()) {
//   on<LoadedNotesState>(_onFetchData as EventHandler<LoadedNotesState, NotesEvent>);
// on<LoadedNotesState>() {
//   emit(const InitialNotesState());
//   final notes = await _interactor.readAll();
//
//   emit(LoadedNotesState(notes));
// }

//}


// Future<void> fetchData() async {
//   emit(LoadedNotesState(await _interactor.readAll ()));
// }

// PostsBloc(this._notesRepository, this._interactor) : super(const PostsState.loading()) {
//   on<_FetchData>(_onFetchData);
// }

// Future<void> _onFetchData(
//     LoadNotesEvent event,
//     Emitter emit,
//     ) async {
//   emit(const InitialNotesState());
//   final notes = await _interactor.readAll();
//
//   emit(LoadedNotesState(notes));
// }

// @override
// Future<void> close() {
//   _interactor.dispose();
//   return super.close();
// }

}




