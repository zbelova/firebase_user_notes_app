import '../../model/subscription_model.dart';
abstract class SubscriptionService {
  Future<void> subscribe(SubscriptionModel subscription);

  Future<SubscriptionModel> checkSubscriptionActive(SubscriptionModel subscription);
}