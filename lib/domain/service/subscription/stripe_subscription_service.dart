
import 'package:firebase_user_notes/domain/model/subscription_model.dart';
import 'package:firebase_user_notes/domain/service/subscription/subscription_service.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionService)
class StripeSubscriptionService implements SubscriptionService {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  @override
  Future<void> subscribe(SubscriptionModel subscription) async {
    try {
      await _subscriptionRepository.subscribe(subscription);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubscriptionModel> checkSubscriptionActive(SubscriptionModel subscription) async {
    try {
      return await _subscriptionRepository.checkSubscriptionActive(subscription);
    } catch (e) {
      rethrow;
    }
  }
}