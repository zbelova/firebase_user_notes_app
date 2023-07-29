import '../model/subscription_model.dart';
abstract class SubscriptionService {
  Future<SubscriptionModel> subscribe(SubscriptionModel subscriptionModel);

  Future<SubscriptionModel> checkSubscriptionActive(SubscriptionModel subscriptionModel);
}