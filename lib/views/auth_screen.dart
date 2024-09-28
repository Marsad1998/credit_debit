import 'package:credit_debit/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/services/auth_services.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const String id = 'login';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthService authService;
  late TextEditingController _pinController;
  bool _hasAttemptedBiometricAuth = false; // To track biometric auth attempts

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    _pinController = TextEditingController();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Check if the user has already set up a PIN
    final hasPin = await authService.hasSetupPin();
    if (hasPin) {
      // If a PIN is set, attempt biometric authentication
      await _attemptBiometricAuthentication();
    } else {
      // If no PIN, show the registration screen for first-time setup
      _showPinRegistrationDialog();
    }
  }

  Future<void> _attemptBiometricAuthentication() async {
    final authenticated = await authService.authenticateWithBiometrics();
    if (authenticated) {
      _redirectToDashboard();
    } else {
      // Only show the PIN dialog if we haven't already attempted biometric auth
      if (!_hasAttemptedBiometricAuth) {
        _hasAttemptedBiometricAuth = true; // Set flag to true
        _showPinLoginDialog();
      }
    }
  }

  void _redirectToDashboard() {
    context.goNamed(DashboardScreen.id);
  }

  // PIN registration dialog for first-time users
  Future<void> _showPinRegistrationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set a 4-Digit PIN'),
          content: TextField(
            controller: _pinController,
            decoration: const InputDecoration(hintText: 'Enter 4-Digit PIN'),
            keyboardType: TextInputType.number,
            obscureText: true,
            autofocus: true,
            maxLength: 4,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_pinController.text.length == 4) {
                  await authService.setPin(_pinController.text);
                  Navigator.of(context).pop();
                  _redirectToDashboard();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN must be 4 digits')));
                }
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  // PIN login dialog for returning users
  Future<void> _showPinLoginDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter PIN'),
          content: TextField(
            controller: _pinController,
            decoration: const InputDecoration(hintText: 'Enter 4-Digit PIN'),
            keyboardType: TextInputType.number,
            obscureText: true,
            autofocus: true,
            maxLength: 4,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final pinSuccess =
                    await authService.verifyPin(_pinController.text);
                if (pinSuccess) {
                  Navigator.of(context).pop();
                  _redirectToDashboard();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid PIN')));
                }
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _attemptBiometricAuthentication(); // Attempt biometric again on button press
              },
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center items horizontally
                children: const [
                  Icon(Icons.lock),
                  SizedBox(width: 8.0), // Add spacing between icon and text
                  Text('Access Your Ledger'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
