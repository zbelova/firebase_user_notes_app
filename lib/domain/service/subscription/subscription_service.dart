import '../../model/subscription_model.dart';
abstract class SubscriptionService {
  Future<void> subscribe(String email, int price);

  Future<SubscriptionModel> checkSubscriptionActive(String email, int duration);
}