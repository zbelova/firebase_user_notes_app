import 'package:firebase_user_notes/domain/model/user_model.dart';
import 'package:injectable/injectable.dart';
import '../../domain/interactor/subscription_interactor.dart';
import '../../domain/interactor/user_interactor.dart';
import '../../domain/model/subscription_model.dart';
import '../../domain/service/subscription/subscription_service.dart';

//цена подписки и ее длительность
const subscribtionDuration = 300000;
const subscribtionPrice = 1000;

@Injectable(as: SubscriptionInteractor)
class DefaultSubscriptionInteractor implements SubscriptionInteractor {
  final SubscriptionService _service;
  final UserInteractor _userInteractor;

  DefaultSubscriptionInteractor(this._service, this._userInteractor);

  @override
  Future<void> subscribe() async {
    try {
      UserModel user = await _userInteractor.loadUser();
      SubscriptionModel subscription = SubscriptionModel(email: user.email, price: subscribtionPrice, duration: subscribtionDuration, deadline: 0);
      await _service.subscribe(subscription);
    } catch (e) {
    //  print(e.toString());
      rethrow;
    }
  }

  @override
  Future<SubscriptionModel> checkSubscriptionActive() async {
    try {
      UserModel user = await _userInteractor.loadUser();
      SubscriptionModel subscription = await _service.checkSubscriptionActive(SubscriptionModel(email: user.email, price: subscribtionPrice, duration: subscribtionDuration, deadline: 0));
      return subscription;
    } catch (e) {
     // print(e.toString());
      rethrow;
    }
  }
}
