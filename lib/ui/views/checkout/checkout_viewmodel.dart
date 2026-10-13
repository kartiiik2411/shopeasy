import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../domain/entities/product.dart';

enum CheckoutPaymentMethod { card, cashOnDelivery, upi }

class CheckoutViewModel extends BaseViewModel {
  CheckoutViewModel({required this.product}) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  final Product product;
  late final Razorpay _razorpay;

  // Replace this with your Razorpay Test Mode Key ID.
  // Never put a Razorpay Key Secret in the Flutter app.
  static const String _razorpayKeyId = 'rzp_test_Tn0VncygJI1hEE';

  int currentStep = 0;
  int quantity = 1;

  CheckoutPaymentMethod paymentMethod = CheckoutPaymentMethod.card;

  String fullName = 'Alex Johnson';
  String street = '123 Main Street, Apt 4B';
  String city = 'San Francisco';
  String state = 'CA';
  String postalCode = '94102';
  String phone = '+1 (555) 123-4567';

  bool isDefaultAddress = true;

  String? paymentId;
  String? razorpayOrderId;
  String? paymentSignature;
  String? paymentError;

  bool orderPlaced = false;
  bool isProcessingPayment = false;

  Completer<bool>? _paymentCompleter;
  Timer? _paymentTimeout;
  bool _disposed = false;

  double get subtotal => product.discountedPrice * quantity;

  double get shipping => subtotal >= 50 ? 0 : 5.99;

  double get total => subtotal + shipping;

  String get formattedAddress => '$street, $city, $state $postalCode';

  void increaseQuantity() {
    if (isProcessingPayment || orderPlaced) return;
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (isProcessingPayment || orderPlaced) return;
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  void selectPaymentMethod(CheckoutPaymentMethod method) {
    if (isProcessingPayment || orderPlaced) return;
    paymentMethod = method;
    paymentError = null;
    notifyListeners();
  }

  void continueToNextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0 && !isProcessingPayment) {
      currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= currentStep && !isProcessingPayment) {
      currentStep = step;
      notifyListeners();
    }
  }

  void updateAddress({
    required String name,
    required String streetAddress,
    required String cityName,
    required String stateName,
    required String zipCode,
    required String phoneNumber,
  }) {
    if (isProcessingPayment || orderPlaced) return;

    fullName = name;
    street = streetAddress;
    city = cityName;
    state = stateName;
    postalCode = zipCode;
    phone = phoneNumber;
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    if (orderPlaced) return true;
    if (isProcessingPayment) return false;

    paymentError = null;
    paymentId = null;
    razorpayOrderId = null;
    paymentSignature = null;

    if (paymentMethod == CheckoutPaymentMethod.cashOnDelivery) {
      setBusy(true);
      try {
        // TODO: Persist the order with paymentStatus: 'pending'.
        orderPlaced = true;
        return true;
      } catch (error) {
        paymentError = 'Could not place order: $error';
        return false;
      } finally {
        setBusy(false);
      }
    }

    if (_razorpayKeyId.contains('REPLACE_WITH_YOUR_KEY_ID')) {
      paymentError =
          'Add your Razorpay Test Mode Key ID before starting payment.';
      notifyListeners();
      return false;
    }

    isProcessingPayment = true;
    setBusy(true);
    notifyListeners();

    final completer = Completer<bool>();
    _paymentCompleter = completer;

    try {
      final options = <String, dynamic>{
        'key': _razorpayKeyId,
        // Razorpay expects the amount in the smallest currency unit.
        // This calculation assumes `total` is already denominated in INR.
        'amount': (total * 100).round(),
        'currency': 'INR',
        'name': 'ShopEasy',
        'description': product.title,
        'method': paymentMethod == CheckoutPaymentMethod.card ? 'card' : 'upi',
        'prefill': {'name': fullName, 'contact': phone},
        'theme': {'color': '#6950AA'},
      };

      _razorpay.open(options);

      // Prevent the UI from waiting forever if no SDK callback arrives.
      _paymentTimeout?.cancel();
      _paymentTimeout = Timer(const Duration(minutes: 3), () {
        if (!completer.isCompleted) {
          paymentError =
              'Payment timed out. Check your payment status before retrying.';
          completer.complete(false);
          notifyListeners();
        }
      });

      return await completer.future;
    } catch (error) {
      paymentError = 'Unable to open Razorpay: $error';
      return false;
    } finally {
      _paymentTimeout?.cancel();
      if (identical(_paymentCompleter, completer)) {
        _paymentCompleter = null;
      }
      isProcessingPayment = false;
      if (!_disposed) {
        setBusy(false);
        notifyListeners();
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentId = response.paymentId;
    razorpayOrderId = response.orderId;
    paymentSignature = response.signature;
    paymentError = null;

    // Demo only: production must verify the payment signature on a backend
    // before treating the order as paid.
    orderPlaced = true;

    final completer = _paymentCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(true);
    }

    if (!_disposed) notifyListeners();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentError = response.message?.trim().isNotEmpty == true
        ? response.message!
        : 'Payment failed or was cancelled. Please try again.';
    orderPlaced = false;

    final completer = _paymentCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }

    if (!_disposed) notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Wallet selection is not proof that a payment succeeded.
    paymentError =
        'Selected wallet: ${response.walletName ?? 'Unknown'}. '
        'Complete payment to place your order.';
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _paymentTimeout?.cancel();

    final completer = _paymentCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }
    _paymentCompleter = null;

    _razorpay.clear();
    super.dispose();
  }
}
