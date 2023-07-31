
import '../model/subscription_model.dart';

abstract class SubscriptionInteractor {
  Future<void> subscribe();

  Future<SubscriptionModel> checkSubscriptionActive();
}