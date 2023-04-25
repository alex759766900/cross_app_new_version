import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentStart>(_onPaymentStart);
    on<PaymentCreateIntent>(_onPaymentCreateIntent);
    on<PaymentConfirmPayment>(_onPaymentConfirmPayment);
  }

  void _onPaymentStart(PaymentStart event, Emitter<PaymentState> emit) {
    emit(state.copyWith(status: PaymentStatus.initial));
  }

  void _onPaymentCreateIntent(
      PaymentCreateIntent event,
      Emitter<PaymentState> emit
      ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final PaymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: event.billingDetails,
        ),
      ),
    );

    final paymentIntentResult = _callPayEndpoointMethod(
      useStripeSdk: true,
      paymentMethodId: paymentMethod.id,
      currency: 'usd',
      items: event.items,
    );

    if (paymentIntentResult['error'] != null) {
      emit(state.copyWith(status: PaymentStatus.failure));
    }

    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {
      emit(state.copyWith(status: PaymentStatus.success));
    }

    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == true) {
      final String clientSecret = paymentIntentResult['clientSecret'];

      add(PaymentConfirmIntent(clientSecret: clientSecret));
    }
  }

  void _onPaymentConfirmPayment(
      PaymentConfirmPayment event,
      Emitter<PaymentState> emit
      ) async {
    try {
      final paymentIntent =
      await Stripe.instance.handleNextActionForPayment(event.clientSecret);
      if (paymentIntent.status == PaymentIntentStatus.requiresConfirmation) {
        Map<String,dynamic> request = await _callPayEndpointIntentId(
          paymentIntentId: paymentIntent.id,
        );

        if(result['error'] != null){
          emit(state.copyWith(status: PaymentStatus.failure));
        } else {
          emit(state.copyWith(status: PaymentStatus.success));
        }
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: PaymentStatus.failure));
    }
  }

  Future<Map<String,dynamic>> _callPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse("https://us-central1-jemma-b0fcd.cloudfunctions.net/StripePayEndpointIntentId");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'paymentIntentId': paymentIntentId,
      }),
    );

    return json.decode(response.body);
  }
}




// import 'dart:convert';
// import 'dart:html';
//
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:meta/meta.dart';
//
// part 'payment_event.dart';
// part 'payment_state.dart';
//
// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   PaymentBloc() : super(const PaymentInitial()) {
//     //PaymentStart
//     on<PaymentStarted>(_onPaymentStarted);
//     on<PaymentCreateIntent>(_onPaymentCreateIntent);
//     // /PaymentConfirmIntent
//     on<PaymentConfirmPayment>(_onPaymentConfirmPayment);
//
//     void _onPaymentStarted(PaymentStarted event, Emitter<PaymentState> emit) {
//       emit(state.copyWith(status: PaymentStatus.initial));
//     }
//
//     void _onPaymentCreateIntent(
//         PaymentCreateIntent event,
//         Emitter<PaymentState> emit
//         ) async {
//       emit(state.copyWith(status: PaymentStatus.loading));
//
//       final PaymentMethod = await Stripe.instance.createPaymentMethod(
//         PaymentMethodParams.card(paymentMethodData: PaymentMethodData(,
//         billingDetails: event.billingDetails,
//         ),
//         );
//
//         final paymentIntentResult = _callPayEndpoointMethod(
//         useStripeSdk: true,
//         paymentMethodId: paymentMethod.id,
//         currency: 'usd',
//         items: event.items,
//       );
//
//       if (paymentIntentResult['error'] != null) {
//         emit(state.copyWith(status: PaymentStatus.failure));
//       }
//
//       if (paymentIntentResult['clientSecret'] != null &&
//           paymentIntentResult['requiresAction'] == null) {
//         emit(state.copyWith(status: PaymentStatus.success));
//       }
//
//       if (paymentIntentResult['clientSecret'] != null &&
//           paymentIntentResult['requiresAction'] == true) {
//         final String clientSecret = paymentIntentResult['clientSecret'];
//
//         add(PaymentConfirmIntent(clientSecret: clientSecret));
//       }
//     }
//
//     void _onpaymentConfirmPayment(
//         PaymentConfirmPayment event,
//         Emitter<PaymentState> emit
//         ) async {
//       try {
//         final paymentIntent =
//           await Stripe.instance.handleNextActionForPayment(event.clientSecret);
//         if (paymentIntent.status == PaymentIntentStatus.requiresConfirmation) {
//           Map<String,dynamic> request = await _callPayEndpointIntentId(
//             paymentIntentId: paymentIntent.id,
//           );
//           if(result['error'] != null){
//             emit(state.copyWith(status: PaymentStatus.failure));
//           } else {
//             emit(state.copyWith(status: PaymentStatus.success));
//           }
//         }
//       } catch (e) {
//         print(err);
//         emit(state.copyWith(status: PaymentStatus.failure));
//       }
//
//
//     }
//
//     Future<Map<String,dynamic>> _callPayEndpointIntentId({
//       required String paymentIntentId,
//       // required String paymentMethodId,
//       // required String currency,
//       // List<Map<String,dynamic>>? items,
//     })async{
//       final url = Uri.parse("https://us-central1-jemma-b0fcd.cloudfunctions.net/StripePayEndpointIntentId");
//
//       final response = await http.post(
//         url,
//         headers:{'Content-Type': 'application/json'},
//         body: json.encode({
//           // 'useStripeSdk': useStripeSdk,
//           // 'paymentMethodId': paymentMethodId,
//           // 'currency': currency,
//           // 'items': items,
//           'paymentIntentId': paymentIntentId,
//         },
//         ),
//       );
//
//       return json.decode(response.body);
//
//     };
//   }
