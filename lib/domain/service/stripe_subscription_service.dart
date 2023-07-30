
import 'package:firebase_user_notes/domain/model/subscription_model.dart';
import 'package:firebase_user_notes/domain/service/subscription_service.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionService)
class StripeSubscriptionService implements SubscriptionService {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  @override
  Future<void> subscribe(String email, int price) async {
    try {
      await _subscriptionRepository.subscribe(email, price);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubscriptionModel> checkSubscriptionActive(String email, int duration) async {
    try {
      return await _subscriptionRepository.checkSubscriptionActive(email, duration);
    } catch (e) {
      rethrow;
    }
  }
}