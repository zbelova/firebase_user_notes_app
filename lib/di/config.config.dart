// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/interactor/default_notes_interactor.dart' as _i8;
import '../data/interactor/default_user_interactor.dart' as _i10;
import '../domain/bloc/edit_profile_cubit.dart' as _i11;
import '../domain/bloc/notes/notes_bloc.dart' as _i12;
import '../domain/bloc/profile_cubit.dart' as _i13;
import '../domain/interactor/notes_interactor.dart' as _i7;
import '../domain/interactor/user_interactor.dart' as _i9;
import '../domain/service/firebase_notes_service.dart' as _i4;
import '../domain/service/firebase_user_service.dart' as _i6;
import '../domain/service/notes_service.dart' as _i3;
import '../domain/service/user_service.dart' as _i5;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.NotesService>(() => _i4.FirebaseNotesService());
  gh.lazySingleton<_i5.UserService>(() => _i6.FirebaseUserService());
  gh.factory<_i7.NotesInteractor>(
      () => _i8.DefaultNotesInteractor(gh<_i3.NotesService>()));
  gh.factory<_i9.UserInteractor>(
      () => _i10.DefaultUserInteractor(gh<_i5.UserService>()));
  gh.factory<_i11.EditProfileCubit>(
      () => _i11.EditProfileCubit(gh<_i9.UserInteractor>()));
  gh.factory<_i12.NotesBloc>(() => _i12.NotesBloc(gh<_i7.NotesInteractor>()));
  gh.factory<_i13.ProfileCubit>(
      () => _i13.ProfileCubit(gh<_i9.UserInteractor>()));
  return getIt;
}
