import 'dart:convert';
import 'dart:developer';

import 'package:firebase_user_notes/domain/model/subscription_model.dart';
import 'package:flutter/material.dart';
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
      int premiumDeadline = 0;
      if (jsonResponse['success'] && jsonResponse['premium']) {
        int serverPremiumDeadline = jsonResponse['premiumDeadline'] - jsonResponse['now'] + 6000;
        premiumDeadline = (serverPremiumDeadline) > 0 ? (serverPremiumDeadline / 1000).round() : 0;
      }
      return SubscriptionModel(
        email: subscription.email,
        price: subscription.price,
        duration: subscription.duration,
        deadline: premiumDeadline,
      );
    } catch (e) {
      if (e is StripeException) {
        throw 'Ошибка Stripe: ${e.error.localizedMessage}';
      } else {
        throw 'Ошибка: ${e.toString()}';
      }
    }
  }

  Future<void> subscribe(SubscriptionModel subscription) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            urlFunctionPaymentIntentRequest,
          ),
          body: {
            'email': subscription.email,
            'amount': subscription.price.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      Stripe.instance.resetPaymentSheetCustomer();
      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Space Notes',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (e is StripeException) {
        throw 'Ошибка Stripe: ${e.error.localizedMessage}';
      } else {
        throw 'Ошибка: ${e.toString()}';
      }
    }
  }
}
