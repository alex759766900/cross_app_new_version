import 'package:flutter/material.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

/// Create a PaymentMethod and call the Stripe.instance.createPaymentMethod method to create a PaymentMethod object:
// Future<void> createPaymentMethod() async {
//   final paymentMethod = await Stripe.instance.createPaymentMethod(
//     PaymentMethodParams.card(
//       billingDetails: BillingDetails(
//         name: 'John Doe', // Replace with actual customer name
//         email: 'john.doe@example.com', // Replace with actual customer email
//       ),
//     ),
//   );
//   // Handle the paymentMethod object as needed
// }


///Use the PaymentMethod object to confirm the payment by calling the Stripe.instance.confirmPaymentMethod method:
// Future<void> confirmPayment(String paymentMethodId, String clientSecret) async {
//   final paymentIntent = await Stripe.instance.confirmPaymentMethod(
//     PaymentIntentParams.clientSecret(clientSecret),
//     paymentMethodId: paymentMethodId,
//   );
//   // Handle the paymentIntent object as needed
// }

///Create a PaymentMethod and call the Stripe.instance.createPaymentMethod method to create a PaymentMethod object:
// CardField(
//   onCardChanged: (card) {
//   // Handle card details as needed
//   },
// ),


///Call the createPaymentMethod and confirmPayment methods when the user submits the payment form, passing in the required parameters as needed.
