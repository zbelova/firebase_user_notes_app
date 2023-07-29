
import 'package:firebase_user_notes/domain/model/subscription_model.dart';
import 'package:firebase_user_notes/domain/service/subscription_service.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionService)
class StripeSubscriptionService implements SubscriptionService {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  @override
  Future<SubscriptionModel> subscribe(SubscriptionModel subscriptionModel) async {
    return await _subscriptionRepository.subscribe(subscriptionModel);
  }

  @override
  Future<SubscriptionModel> checkSubscriptionActive(SubscriptionModel subscriptionModel) async {
    return await _subscriptionRepository.checkSubscriptionActive(subscriptionModel);
  }
}