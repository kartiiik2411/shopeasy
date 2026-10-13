import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../domain/entities/product.dart';

import 'checkout_viewmodel.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key, required this.product});

  final Product product;

  static const Color purple = Color(0xFF6950AA);

  static const Color background = Color(0xFFF8F7FC);

  static const Color border = Color(0xFFE8E3F1);

  static const Color textColor = Color(0xFF262238);

  static const Color secondary = Color(0xFF777286);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(product: product),

      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: background,

          appBar: AppBar(
            backgroundColor: background,

            elevation: 0,

            surfaceTintColor: Colors.transparent,

            leading: IconButton(
              icon: const Icon(Icons.arrow_back),

              onPressed: () {
                if (vm.currentStep > 0) {
                  vm.goToPreviousStep();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),

            title: const Text(
              'Checkout',

              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
          ),

          body: Column(
            children: [
              _stepIndicator(vm),

              const Divider(height: 1, color: border),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),

                  child: SingleChildScrollView(
                    key: ValueKey(vm.currentStep),

                    padding: const EdgeInsets.all(20),

                    child: switch (vm.currentStep) {
                      0 => _addressStep(context, vm),

                      1 => _paymentStep(vm),

                      _ => _reviewStep(vm),
                    },
                  ),
                ),
              ),

              const Divider(height: 1, color: border),

              SafeArea(
                top: false,

                minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),

                child: SizedBox(
                  width: double.infinity,

                  height: 54,

                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: purple,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    onPressed: vm.isBusy
                        ? null
                        : () async {
                            if (vm.currentStep < 2) {
                              vm.continueToNextStep();

                              return;
                            }

                            final success = await vm.placeOrder();

                            if (!context.mounted) return;

                            if (success) {
                              await showDialog<void>(
                                context: context,

                                barrierDismissible: false,

                                builder: (dialogContext) => AlertDialog(
                                  icon: const Icon(
                                    Icons.check_circle,

                                    color: purple,

                                    size: 54,
                                  ),

                                  title: const Text('Order placed!'),

                                  content: const Text(
                                    'This is a checkout demo. '
                                    'No real payment was processed.',
                                  ),

                                  actions: [
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();

                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      },

                                      child: const Text('Done'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },

                    child: vm.isBusy
                        ? const SizedBox(
                            height: 22,

                            width: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,

                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                vm.currentStep == 2
                                    ? 'Place Order · \$${vm.total.toStringAsFixed(2)}'
                                    : 'Continue',

                                style: const TextStyle(
                                  fontSize: 16,

                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Icon(
                                vm.currentStep == 2
                                    ? Icons.check
                                    : Icons.chevron_right,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stepIndicator(CheckoutViewModel vm) {
    const labels = ['Address', 'Payment', 'Review'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),

      child: Row(
        children: List.generate(3, (index) {
          final completed = index < vm.currentStep;

          final active = index == vm.currentStep;

          return Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,

                  backgroundColor: active || completed
                      ? purple
                      : const Color(0xFFF0EDF6),

                  child: completed
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),

                const SizedBox(width: 6),

                Flexible(
                  child: Text(
                    labels[index],

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: active ? purple : secondary,

                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,

                      fontSize: 12,
                    ),
                  ),
                ),

                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2,

                      margin: const EdgeInsets.symmetric(horizontal: 6),

                      color: index < vm.currentStep ? purple : border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _heading(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: textColor,

            fontSize: 20,

            fontWeight: FontWeight.w700,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 5),

          Text(subtitle, style: const TextStyle(color: secondary)),
        ],

        const SizedBox(height: 18),
      ],
    );
  }

  Widget _addressStep(BuildContext context, CheckoutViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _heading(
          'Delivery Address',

          subtitle: 'Where should we deliver your order?',
        ),

        Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: const Color(0xFFF0EDF8),

            border: Border.all(color: purple, width: 1.5),

            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vm.fullName,

                      style: const TextStyle(
                        color: textColor,

                        fontSize: 17,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Icon(Icons.check_circle, color: purple),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                '${vm.street}\n${vm.city}, ${vm.state} ${vm.postalCode}\n${vm.phone}',

                style: const TextStyle(color: secondary, height: 1.6),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,

                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFE5DFF2),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  'DEFAULT',

                  style: TextStyle(
                    color: purple,

                    fontSize: 11,

                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,

                child: TextButton.icon(
                  onPressed: () => _showAddressEditor(context, vm),

                  icon: const Icon(Icons.edit_outlined, size: 18),

                  label: const Text('Edit address'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        OutlinedButton.icon(
          onPressed: () => _showAddressEditor(context, vm, clear: true),

          icon: const Icon(Icons.add),

          label: const Text('Add New Address'),

          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),

            foregroundColor: purple,

            side: const BorderSide(color: border, style: BorderStyle.solid),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        const SizedBox(height: 24),

        _infoCard(
          Icons.local_shipping_outlined,

          'Estimated delivery',

          'Usually delivered within 3–5 business days',
        ),
      ],
    );
  }

  Future<void> _showAddressEditor(
    BuildContext context,

    CheckoutViewModel vm, {

    bool clear = false,
  }) async {
    final name = TextEditingController(text: clear ? '' : vm.fullName);

    final street = TextEditingController(text: clear ? '' : vm.street);

    final city = TextEditingController(text: clear ? '' : vm.city);

    final state = TextEditingController(text: clear ? '' : vm.state);

    final zip = TextEditingController(text: clear ? '' : vm.postalCode);

    final phone = TextEditingController(text: clear ? '' : vm.phone);

    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,

      builder: (dialogContext) => AlertDialog(
        title: Text(clear ? 'Add new address' : 'Edit address'),

        content: SizedBox(
          width: 420,

          child: Form(
            key: formKey,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  _addressField(name, 'Full name'),

                  _addressField(street, 'Street address'),

                  _addressField(city, 'City'),

                  _addressField(state, 'State'),

                  _addressField(zip, 'Postal code'),

                  _addressField(
                    phone,

                    'Phone number',

                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),

            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;

              vm.updateAddress(
                name: name.text.trim(),

                streetAddress: street.text.trim(),

                cityName: city.text.trim(),

                stateName: state.text.trim(),

                zipCode: zip.text.trim(),

                phoneNumber: phone.text.trim(),
              );

              Navigator.pop(dialogContext);
            },

            child: const Text('Save address'),
          ),
        ],
      ),
    );

    name.dispose();

    street.dispose();

    city.dispose();

    state.dispose();

    zip.dispose();

    phone.dispose();
  }

  Widget _addressField(
    TextEditingController controller,

    String label, {

    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: TextFormField(
        controller: controller,

        keyboardType: keyboardType,

        decoration: InputDecoration(
          labelText: label,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),

        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _paymentStep(CheckoutViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _heading(
          'Payment Method',

          subtitle: 'Choose how you would like to pay',
        ),

        _paymentOption(
          vm,

          CheckoutPaymentMethod.card,

          Icons.credit_card_outlined,

          'Credit / Debit Card',

          'Visa, Mastercard, Amex',
        ),

        _paymentOption(
          vm,

          CheckoutPaymentMethod.cashOnDelivery,

          Icons.inventory_2_outlined,

          'Cash on Delivery',

          'Pay when you receive',
        ),

        _paymentOption(
          vm,

          CheckoutPaymentMethod.upi,

          Icons.bolt_outlined,

          'UPI Payment',

          'Instant bank transfer',
        ),

        const SizedBox(height: 12),

        _infoCard(
          Icons.lock_outline,

          'Secure checkout',

          'Payment processing is not connected in this demo.',
        ),
      ],
    );
  }

  Widget _paymentOption(
    CheckoutViewModel vm,

    CheckoutPaymentMethod method,

    IconData icon,

    String title,

    String subtitle,
  ) {
    final selected = vm.paymentMethod == method;

    return InkWell(
      onTap: () => vm.selectPaymentMethod(method),

      borderRadius: BorderRadius.circular(18),

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0EDF8) : Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: selected ? purple : border,

            width: selected ? 1.5 : 1,
          ),
        ),

        child: Row(
          children: [
            Container(
              height: 54,

              width: 54,

              decoration: BoxDecoration(
                color: selected ? purple : const Color(0xFFEDE7F7),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(icon, color: selected ? Colors.white : purple),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      color: textColor,

                      fontSize: 16,

                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(subtitle, style: const TextStyle(color: secondary)),
                ],
              ),
            ),

            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,

              color: selected ? purple : border,
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewStep(CheckoutViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _heading(
          'Order Review',

          subtitle: 'Check everything before placing your order',
        ),

        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Order Items',

                style: const TextStyle(
                  color: textColor,

                  fontSize: 17,

                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Container(
                      height: 82,

                      width: 82,

                      color: background,

                      padding: const EdgeInsets.all(6),

                      child: Image.network(
                        product.thumbnail,

                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          product.title,

                          style: const TextStyle(
                            color: textColor,

                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Qty: ${vm.quantity}',

                          style: const TextStyle(color: secondary),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '\$${(product.discountedPrice * vm.quantity).toStringAsFixed(2)}',

                          style: const TextStyle(
                            color: textColor,

                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        onPressed: vm.decreaseQuantity,

                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      IconButton(
                        onPressed: vm.increaseQuantity,

                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_outlined, color: purple, size: 20),

                  SizedBox(width: 8),

                  Text(
                    'Delivering to',

                    style: TextStyle(
                      color: textColor,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                vm.fullName,

                style: const TextStyle(
                  color: textColor,

                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${vm.formattedAddress}\n${vm.phone}',

                style: const TextStyle(color: secondary, height: 1.5),
              ),

              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () => vm.goToStep(0),

                  child: const Text('Change'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        _sectionCard(
          child: Column(
            children: [
              _summaryRow('Subtotal', vm.subtotal),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Expanded(
                    child: Text('Shipping', style: TextStyle(color: secondary)),
                  ),

                  Text(
                    vm.shipping == 0
                        ? 'FREE'
                        : '\$${vm.shipping.toStringAsFixed(2)}',

                    style: TextStyle(
                      color: vm.shipping == 0 ? Colors.green : textColor,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),

                child: Divider(color: border),
              ),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Total',

                      style: TextStyle(
                        color: textColor,

                        fontSize: 18,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Text(
                    '\$${vm.total.toStringAsFixed(2)}',

                    style: const TextStyle(
                      color: purple,

                      fontSize: 22,

                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'Payment: ${_paymentLabel(vm.paymentMethod)}',

                  style: const TextStyle(color: secondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _paymentLabel(CheckoutPaymentMethod method) {
    return switch (method) {
      CheckoutPaymentMethod.card => 'Credit / Debit Card',

      CheckoutPaymentMethod.cashOnDelivery => 'Cash on Delivery',

      CheckoutPaymentMethod.upi => 'UPI Payment',
    };
  }

  Widget _summaryRow(String label, double amount) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: secondary)),
        ),

        Text(
          '\$${amount.toStringAsFixed(2)}',

          style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: border),
      ),

      child: child,
    );
  }

  Widget _infoCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: border),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Icon(icon, color: purple),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: textColor,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(subtitle, style: const TextStyle(color: secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
