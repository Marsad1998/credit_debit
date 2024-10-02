import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  static bool _isSupported = false;

  AuthService() {
    _initializeSupportStatus();
  }

  Future<void> _initializeSupportStatus() async {
    _isSupported = await _auth.isDeviceSupported();
  }

  static bool isSupported() {
    return _isSupported;
  }

  Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication Required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        localizedReason: 'Please authenticate to access your account',
      );
    } catch (e) {
      // Check if the error is about biometric unavailability
      if (e is PlatformException && e.code == 'NotAvailable') {
        debugPrint('Biometric authentication is not available.');
      } else {
        debugPrint('Biometric authentication error: $e');
      }
      return false;
    }
  }

  Future<bool> hasSetupPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userPin');
  }

  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPin', pin);
  }

  Future<bool> verifyPin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('userPin');
    return enteredPin == storedPin;
  }
}
