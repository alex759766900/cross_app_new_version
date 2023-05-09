
part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  List<Object> get props => [];
}

class PaymentStart extends PaymentEvent {}

class PaymentCreateIntent extends PaymentEvent {
  final BillingDetails billingDetails;
  final List<Map<String, dynamic>> items;

  const PaymentCreateIntent({
    required this.billingDetails,
    required this.items,
  });

  @override
  List<Object> get props => [billingDetails, items];
}

class PaymentConfirmIntent extends PaymentEvent {
  final String clientSecret;

  const PaymentConfirmIntent({required this.clientSecret,});

  @override
  List<Object> get props => [clientSecret];
}
