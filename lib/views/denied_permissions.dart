import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Separate page to explain why permissions are needed
class PermissionDeniedPage extends StatelessWidget {
  final Future<void> Function() onGrant;

  const PermissionDeniedPage({required this.onGrant, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Storage Permission Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
                textAlign: TextAlign.center,
                'Please enable storage access to use this app. We need this permission because we need to store pdf'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await Permission.storage.request(); // Ask for permission again
                await onGrant(); // Call the permission check function again
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
