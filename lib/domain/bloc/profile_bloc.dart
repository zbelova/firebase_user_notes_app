import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../interactor/user_interactor.dart';
import '../model/user_model.dart';

@Injectable()

class ProfileCubit extends Cubit<ProfileState> {
  final UserInteractor _interactor;


  ProfileCubit(this._interactor) : super(const InitialProfileState());

  Future<void> fetchData() async {
    emit(LoadedProfileState(await _interactor.loadUser()));
  }

}

// Базовое состояние экрана
class ProfileState {
  const ProfileState();
}

// Начальное состояние экрана
class InitialProfileState extends ProfileState {
  const InitialProfileState();
}

// Состояние экрана с уже загруженными данными
class LoadedProfileState extends ProfileState {
  final UserModel user;

  const LoadedProfileState(this.user);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoadedProfileState && runtimeType == other.runtimeType && user == other.user;

  @override
  int get hashCode => user.hashCode;
}