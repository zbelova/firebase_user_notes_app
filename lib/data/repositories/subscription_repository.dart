import 'dart:convert';
import 'dart:developer';

import 'package:firebase_user_notes/domain/model/subscription_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../keys.dart';

class SubscriptionRepository {
  Future<SubscriptionModel> checkSubscriptionActive(SubscriptionModel subscription) async {
    try {
      final response = await http.post(
          Uri.parse(
            urlFunctionCheckPremium,
          ),
          body: {
            'email': subscription.email,
            'premiumDuration': subscription.duration.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      //print(jsonResponse.toString());

      int serverPremiumDeadline = jsonResponse['premiumDeadline'] - jsonResponse['now'] + 6000;
      int premiumDeadline = (serverPremiumDeadline) > 0 ? (serverPremiumDeadline / 1000).round() : 0;

      return SubscriptionModel(
        email: subscription.email,
        price: subscription.price,
        duration: subscription.duration,
        deadline: premiumDeadline,
      );
    } catch (e) {
      //print(e.toString());
      if (e is StripeException) {
        return 'Error from Stripe: ${e.error.localizedMessage}'; //???
      } else {
        return e.toString(); //???
      }
    }
  }
}
