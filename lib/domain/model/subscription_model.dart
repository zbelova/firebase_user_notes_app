class SubscriptionModel {
  final String email;
  int? price;
  int? duration;
  int? deadline;

  SubscriptionModel({
    required this.email,
    this.price,
    this.duration,
    this.deadline,
  });
}
