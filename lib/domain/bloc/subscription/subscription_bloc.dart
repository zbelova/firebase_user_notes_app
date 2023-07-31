
import 'dart:async';

import 'package:firebase_user_notes/domain/bloc/subscription/subscription_event.dart';
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../interactor/subscription_interactor.dart';
import '../../model/subscription_model.dart';

@Injectable()

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionInteractor _interactor;

  SubscriptionBloc(this._interactor) : super(const LoadingSubscriptionState()) {
    on<SubscribeEvent>(_onSubscribeEvent);
    on<CheckSubscriptionEvent>(_onCheckSubscriptionEvent);
    add(CheckSubscriptionEvent());
  }

  FutureOr<void> _onSubscribeEvent(SubscribeEvent event, Emitter<SubscriptionState> emit) async {
    try {
      await _interactor.subscribe();
    } catch (e) {
      emit(SubscriptionErrorState());
    }
  }

  FutureOr<void> _onCheckSubscriptionEvent(CheckSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    emit(const LoadingSubscriptionState());
    try {
      SubscriptionModel subscription = await _interactor.checkSubscriptionActive();
      if (subscription.deadline > 0) {
        emit(ActiveSubscriptionState(subscription: subscription));
      } else {
        emit(const InactiveSubscriptionState());
      }
    } catch (e) {
      emit(SubscriptionErrorState());
    }
  }
}