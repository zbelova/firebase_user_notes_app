
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_event.dart';
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../interactor/subscription_interactor.dart';

@Injectable()

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionInteractor _interactor;

  SubscriptionBloc(this._interactor) : super(const LoadingSubscriptionState()) {
    on<SubscribeEvent>(_onSubscribeEvent);
    on<CheckSubscriptionEvent>(_onCheckSubscriptionEvent);
    add(CheckSubscriptionEvent());
  }
}