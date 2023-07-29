const subscribtionDuration = 30;
const subscribtionPrice = 10;

class SubscriptionModel {
  final String email;
  final int price;
  final int duration;
  final int deadline;

  SubscriptionModel({
   required this.email,
   this.price = subscribtionPrice,
   this.duration = subscribtionDuration,
   this.deadline = 0,
  });
}
