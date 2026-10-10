import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  static const Color _purple = Color(0xFF6750A4);
  static const Color _background = Color(0xFFF8F7FC);
  static const Color _fieldColor = Color(0xFFF1EFF7);
  static const Color _foreground = Color(0xFF201A2C);
  static const Color _secondary = Color(0xFF716B7C);
  static const Color _border = Color(0xFFE9E5F0);

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = (width * 0.075).clamp(20.0, 36.0);

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(viewModel, horizontalPadding),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          28,
                          horizontalPadding,
                          32,
                        ),
                        child: Form(
                          key: viewModel.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _modeSelector(viewModel),
                              const SizedBox(height: 28),

                              if (viewModel.isRegisterMode) ...[
                                _fieldLabel('Full Name'),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: viewModel.nameController,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  validator: viewModel.validateName,
                                  decoration: _inputDecoration(
                                    hint: 'Alex Johnson',
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              _fieldLabel('Email Address'),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: viewModel.emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                validator: viewModel.validateEmail,
                                decoration: _inputDecoration(
                                  hint: 'you@example.com',
                                ),
                              ),
                              const SizedBox(height: 24),

                              _fieldLabel('Password'),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: viewModel.passwordController,
                                obscureText: viewModel.obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: [
                                  viewModel.isRegisterMode
                                      ? AutofillHints.newPassword
                                      : AutofillHints.password,
                                ],
                                validator: viewModel.validatePassword,
                                onFieldSubmitted: (_) => viewModel.submit(),
                                decoration: _inputDecoration(
                                  hint: 'Enter your password',
                                  suffixIcon: IconButton(
                                    tooltip: viewModel.obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                    onPressed:
                                        viewModel.togglePasswordVisibility,
                                    icon: Icon(
                                      viewModel.obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: _secondary,
                                    ),
                                  ),
                                ),
                              ),

                              if (!viewModel.isRegisterMode) ...[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: viewModel.isSubmitting
                                        ? null
                                        : viewModel.forgotPassword,
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: _purple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else
                                const SizedBox(height: 26),

                              if (viewModel.errorMessage != null) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.errorMessage!.startsWith(
                                          'Password reset email',
                                        )
                                        ? const Color(0xFFE7F5EA)
                                        : const Color(0xFFFFE9EC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: TextStyle(
                                      color:
                                          viewModel.errorMessage!.startsWith(
                                            'Password reset email',
                                          )
                                          ? const Color(0xFF236B38)
                                          : const Color(0xFFB42336),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],

                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: viewModel.isSubmitting
                                      ? null
                                      : viewModel.submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _purple,
                                    disabledBackgroundColor: _purple.withValues(
                                      alpha: 0.65,
                                    ),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: viewModel.isSubmitting
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.3,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          viewModel.isRegisterMode
                                              ? 'Create Account'
                                              : 'Sign In',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),
                              _orDivider(),
                              const SizedBox(height: 24),

                              SizedBox(
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: viewModel.isSubmitting
                                      ? null
                                      : viewModel.signInWithGoogle,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _foreground,
                                    side: const BorderSide(color: _border),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _GoogleMark(),
                                      SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          'Continue with Google',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    viewModel.isRegisterMode
                                        ? 'Already have an account? '
                                        : "Don't have an account? ",
                                    style: const TextStyle(
                                      color: _secondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: viewModel.isSubmitting
                                        ? null
                                        : viewModel.toggleMode,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 4,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      viewModel.isRegisterMode
                                          ? 'Sign In'
                                          : 'Register',
                                      style: const TextStyle(
                                        color: _purple,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(LoginViewModel viewModel, double horizontalPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        28,
        horizontalPadding,
        52,
      ),
      decoration: const BoxDecoration(
        color: _purple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: _purple,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              const Flexible(
                child: Text(
                  'ShopEasy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Column(
              key: ValueKey(viewModel.isRegisterMode),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.isRegisterMode ? 'Join ShopEasy' : 'Welcome back!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.isRegisterMode
                      ? 'Create your free account today'
                      : 'Sign in to continue shopping',
                  style: const TextStyle(
                    color: Color(0xFFD6CBEF),
                    fontSize: 17,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeSelector(LoginViewModel viewModel) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _modeButton(
            label: 'Sign In',
            selected: !viewModel.isRegisterMode,
            onPressed: viewModel.isSubmitting
                ? null
                : () {
                    if (viewModel.isRegisterMode) {
                      viewModel.toggleMode();
                    }
                  },
          ),
          _modeButton(
            label: 'Register',
            selected: viewModel.isRegisterMode,
            onPressed: viewModel.isSubmitting
                ? null
                : () {
                    if (!viewModel.isRegisterMode) {
                      viewModel.toggleMode();
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _modeButton({
    required String label,
    required bool selected,
    required VoidCallback? onPressed,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? _foreground : _secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _foreground,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF918B9B), fontSize: 16),
      filled: true,
      fillColor: _fieldColor,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: _purple, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFE65366)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFE65366), width: 1.4),
      ),
    );
  }

  Widget _orDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: _border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or', style: TextStyle(color: _secondary, fontSize: 14)),
        ),
        Expanded(child: Divider(color: _border)),
      ],
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        color: Color(0xFF4285F4),
        fontSize: 25,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
