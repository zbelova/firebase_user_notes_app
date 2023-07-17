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

import '../data/interactor/default_user_interactor.dart' as _i6;
import '../domain/bloc/profile_bloc.dart' as _i7;
import '../domain/interactor/user_interactor.dart' as _i5;
import '../domain/service/firebase_user_service.dart' as _i4;
import '../domain/service/user_service.dart' as _i3;

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
  gh.lazySingleton<_i3.UserService>(() => _i4.FirebaseUserService());
  gh.factory<_i5.UserInteractor>(
      () => _i6.DefaultUserInteractor(gh<_i3.UserService>()));
  gh.factory<_i7.ProfileCubit>(
      () => _i7.ProfileCubit(gh<_i5.UserInteractor>()));
  return getIt;
}
