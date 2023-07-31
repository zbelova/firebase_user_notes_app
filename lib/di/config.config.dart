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

import '../data/interactor/default_notes_interactor.dart' as _i10;
import '../data/interactor/default_subscription_interactor.dart' as _i17;
import '../data/interactor/default_user_interactor.dart' as _i12;
import '../domain/bloc/edit_profile_cubit.dart' as _i13;
import '../domain/bloc/notes/notes_bloc.dart' as _i14;
import '../domain/bloc/profile_cubit.dart' as _i15;
import '../domain/bloc/subscription/subscription_bloc.dart' as _i18;
import '../domain/interactor/notes_interactor.dart' as _i9;
import '../domain/interactor/subscription_interactor.dart' as _i16;
import '../domain/interactor/user_interactor.dart' as _i11;
import '../domain/service/notes/firebase_notes_service.dart' as _i4;
import '../domain/service/notes/notes_service.dart' as _i3;
import '../domain/service/subscription/stripe_subscription_service.dart' as _i6;
import '../domain/service/subscription/subscription_service.dart' as _i5;
import '../domain/service/user/firebase_user_service.dart' as _i8;
import '../domain/service/user/user_service.dart' as _i7;

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
  gh.lazySingleton<_i5.SubscriptionService>(
      () => _i6.StripeSubscriptionService());
  gh.lazySingleton<_i7.UserService>(() => _i8.FirebaseUserService());
  gh.factory<_i9.NotesInteractor>(
      () => _i10.DefaultNotesInteractor(gh<_i3.NotesService>()));
  gh.factory<_i11.UserInteractor>(
      () => _i12.DefaultUserInteractor(gh<_i7.UserService>()));
  gh.factory<_i13.EditProfileCubit>(
      () => _i13.EditProfileCubit(gh<_i11.UserInteractor>()));
  gh.factory<_i14.NotesBloc>(() => _i14.NotesBloc(gh<_i9.NotesInteractor>()));
  gh.factory<_i15.ProfileCubit>(
      () => _i15.ProfileCubit(gh<_i11.UserInteractor>()));
  gh.factory<_i16.SubscriptionInteractor>(
      () => _i17.DefaultSubscriptionInteractor(
            gh<_i5.SubscriptionService>(),
            gh<_i11.UserInteractor>(),
          ));
  gh.factory<_i18.SubscriptionBloc>(
      () => _i18.SubscriptionBloc(gh<_i16.SubscriptionInteractor>()));
  return getIt;
}
