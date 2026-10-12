import 'package:stacked/stacked.dart';

import '../../../domain/entities/product.dart';

enum CheckoutPaymentMethod { card, cashOnDelivery, upi }

class CheckoutViewModel extends BaseViewModel {
  CheckoutViewModel({required this.product});

  final Product product;

  int currentStep = 0;
  int quantity = 1;

  CheckoutPaymentMethod paymentMethod = CheckoutPaymentMethod.card;

  // Demo address. Replace with your saved-address service later.
  String fullName = 'Alex Johnson';
  String street = '123 Main Street, Apt 4B';
  String city = 'San Francisco';
  String state = 'CA';
  String postalCode = '94102';
  String phone = '+1 (555) 123-4567';

  bool isDefaultAddress = true;

  double get subtotal => product.discountedPrice * quantity;

  double get shipping => subtotal >= 50 ? 0 : 5.99;

  double get total => subtotal + shipping;

  String get formattedAddress => '$street, $city, $state $postalCode';

  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  void selectPaymentMethod(CheckoutPaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  void continueToNextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= currentStep) {
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
    fullName = name;
    street = streetAddress;
    city = cityName;
    state = stateName;
    postalCode = zipCode;
    phone = phoneNumber;
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    // UI demonstration only. Connect your order repository
    // and payment provider before using this in production.
    setBusy(true);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return true;
    } finally {
      setBusy(false);
    }
  }
}
