import 'package:injectable/injectable.dart';
import '../../domain/interactor/subscription_interactor.dart';
import '../../domain/model/subscription_model.dart';
import '../../domain/service/subscription/subscription_service.dart';

//цена подписки и ее длительность
const subscribtionDuration = 30;
const subscribtionPrice = 10;

@Injectable(as: SubscriptionInteractor)
class DefaultSubscriptionInteractor implements SubscriptionInteractor {
 final SubscriptionService _service;

  DefaultSubscriptionInteractor(this._service);

  @override
  Future<void> subscribe(String email) async {
    try {
      await _service.subscribe(email, subscribtionPrice);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    // SubscriptionModel subscription = await _service.subscribe(email, subscribtionPrice);
    // subscription.deadline = 0;
    // subscription.duration = subscribtionDuration;
    // subscription.price = subscribtionPrice;
    // return subscription;
  }

  @override
  Future<SubscriptionModel> checkSubscriptionActive(String email) async {
    try {
      SubscriptionModel subscription = await _service.checkSubscriptionActive(email, subscribtionDuration);
      subscription.duration = subscribtionDuration;
      subscription.price = subscribtionPrice;
      return subscription;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

}