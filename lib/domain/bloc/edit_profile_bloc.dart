import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../interactor/user_interactor.dart';
import '../model/user_model.dart';

@Injectable()

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserInteractor _interactor;


  EditProfileCubit(this._interactor) : super(const InitialEditProfileState());

  Future<void> fetchData() async {
    //print("fetchData");
    if(await _interactor.isLogged()) {
      emit(LoadedEditProfileState(await _interactor.loadUser())); }
    else {
      emit(const SignUpEditProfileState());
      return;
    }
  }
}

// Базовое состояние экрана
class EditProfileState {
  const EditProfileState();
}

// Начальное состояние экрана
class InitialEditProfileState extends EditProfileState {
  const InitialEditProfileState();
}

// Состояние экрана с уже загруженными данными
class LoadedEditProfileState extends EditProfileState {
  final UserModel user;

  const LoadedEditProfileState(this.user);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoadedEditProfileState && runtimeType == other.runtimeType && user == other.user;

  @override
  int get hashCode => user.hashCode;
}

// Регистрация нового пользователя
class SignUpEditProfileState extends EditProfileState {
  const SignUpEditProfileState();
}