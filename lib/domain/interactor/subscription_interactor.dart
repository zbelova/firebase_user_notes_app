
import '../model/subscription_model.dart';

abstract class SubscriptionInteractor {
  Future<void> subscribe(String email);

  Future<SubscriptionModel> checkSubscriptionActive(String email);
}