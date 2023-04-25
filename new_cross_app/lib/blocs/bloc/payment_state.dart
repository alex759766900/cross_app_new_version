part of 'payment_bloc.dart';

enum PaymentStatus { initial, loading, success, failure }

@immutable
class PaymentState extends Equatable {
  final PaymentStatus status;
  final CardFieldInputDetails cardFieldInputDetails;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.cardFieldInputDetails = const CardFieldInputDetails(complete: false),
  });

  PaymentState copyWith({
    PaymentStatus? status,
    CardFieldInputDetails? cardFieldInputDetails,
  }) {
    return PaymentState(
      status: status ?? this.status,
      cardFieldInputDetails:
      cardFieldInputDetails ?? this.cardFieldInputDetails,
    );
  }

  List<Object> get props => [status, cardFieldInputDetails];
}

class PaymentInitial extends PaymentState {}
