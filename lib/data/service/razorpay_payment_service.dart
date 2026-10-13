import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../core/config/payment_config.dart';

class RazorpayPaymentService {
  RazorpayPaymentService() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  late final Razorpay _razorpay;
  Completer<PaymentResult>? _completer;

  Future<PaymentResult> pay({
    required int amountInPaise,
    required String method,
    required String productName,
    required String email,
    required String contact,
  }) {
    if (_completer != null && !_completer!.isCompleted) {
      return Future.value(
        PaymentResult.failure('A payment is already in progress.'),
      );
    }

    _completer = Completer<PaymentResult>();

    final options = <String, dynamic>{
      'key': PaymentConfig.razorpayKeyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'ShopEasy',
      'description': productName,
      'method': method, // 'card' or 'upi'
      'prefill': {'email': email, 'contact': contact},
      'theme': {'color': '#6950AA'},
    };

    try {
      _razorpay.open(options);
    } catch (error) {
      _complete(PaymentResult.failure('Could not open Razorpay: $error'));
    }

    return _completer!.future;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _complete(
      PaymentResult.success(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _complete(
      PaymentResult.failure(
        response.message ?? 'Payment failed or was cancelled.',
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selection is not a confirmed payment.
  }

  void _complete(PaymentResult result) {
    final completer = _completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _completer = null;
  }

  void dispose() {
    _razorpay.clear();
  }
}

class PaymentResult {
  const PaymentResult({
    required this.success,
    this.paymentId,
    this.orderId,
    this.signature,
    this.message,
  });

  factory PaymentResult.success({
    required String paymentId,
    required String orderId,
    required String signature,
  }) {
    return PaymentResult(
      success: true,
      paymentId: paymentId,
      orderId: orderId,
      signature: signature,
    );
  }

  factory PaymentResult.failure(String message) {
    return PaymentResult(success: false, message: message);
  }

  final bool success;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? message;
}
