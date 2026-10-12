import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app.router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Object? _error;
  bool _checkingSession = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    if (_checkingSession) return;
    _checkingSession = true;
    setState(() => _error = null);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = user == null ? null : await user.getIdToken();
      if (!mounted) return;
      final route = token == null || token.isEmpty
          ? Routes.loginView
          : Routes.homeView;
      await Navigator.of(context).pushReplacementNamed(route);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      _checkingSession = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    return Scaffold(
      body: Center(
        child: error == null
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting ShopEasy ready...'),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Could not check your sign-in session: $error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _checkSession,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
