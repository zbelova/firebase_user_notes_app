import 'package:flutter_bloc/flutter_bloc.dart';
import '../interactor/notes_interactor.dart';
import 'notes_event.dart';
import 'notes_state.dart';

@Injectable()

class NotesBloc extends Bloc<NotesState, NotesEvent> {
  final NotesInteractor _interactor;

  NotesBloc(this._interactor) : super(const InitialNotesState()) {
    on<LoadNotesEvent>(_onFetchData);
  }

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
  //   emit(LoadedNotesState(await _interactor.readAll()));
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




