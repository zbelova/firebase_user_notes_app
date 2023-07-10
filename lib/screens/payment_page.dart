import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_user_notes/firebase/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

const url = "https://us-central1-mobile-lesson-19-2.cloudfunctions.net/stripePaymentIntentRequest";

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key, required this.authRepository}) : super(key: key);
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Demo App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => initPaymentSheet(context, email: "example@gmail.com", amount: 200000),
              child: const Text(
                'Buy Honey for all my Money!',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
  try {
    // 1. create payment intent on the server
    final response = await http.post(
        Uri.parse(
          url,
        ),
        body: {
          'email': email,
          'amount': amount.toString(),
        });

    final jsonResponse = jsonDecode(response.body);
    log(jsonResponse.toString());

    //2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Flutter Stripe Store Demo',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        style: ThemeMode.light,
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment completed!')),
    );
  } catch (e) {
    log(e.toString());
    if (e is StripeException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error from Stripe: ${e.error.localizedMessage}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
