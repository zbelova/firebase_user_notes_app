
import '../../model/subscription_model.dart';

sealed class SubscriptionState {
  const SubscriptionState();
}

class InactiveSubscriptionState extends SubscriptionState {
  const InactiveSubscriptionState();
}

class LoadingSubscriptionState extends SubscriptionState {
  const LoadingSubscriptionState();
}

class ActiveSubscriptionState extends SubscriptionState {
  final SubscriptionModel subscription;

  ActiveSubscriptionState({required this.subscription});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ActiveSubscriptionState && runtimeType == other.runtimeType && subscription == other.subscription;

  @override
  int get hashCode => subscription.hashCode;

}

class SubscriptionErrorState extends SubscriptionState {}