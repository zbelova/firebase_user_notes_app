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
    emit(LoadedEditProfileState(await _interactor.loadUser()));
  }

  // Future<void> editUser(UserModel user) async {
  //   emit(LoadedEditProfileState(await _interactor.editUser(user))
  // }
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