import 'package:credit_debit/views/auth_screen.dart';
import 'package:credit_debit/views/dashboard_screen.dart';
import 'package:credit_debit/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      backgroundColor: kScaffoldColor,
      elevation: 50,
      shadowColor: Colors.lightBlueAccent,
      child: DrawerHeader(
        child: Center(
          child: Column(
            children: [
              // Logo image
              const Icon(
                Icons.receipt_long, // Replace with your logo widget
                size: 100.0, // Larger size for the big logo effect
                color: Colors.lightBlueAccent,
              ),
              const SizedBox(height: 10),
              const Text(
                'Smart Records',
                style: kH2,
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  context.goNamed(DashboardScreen.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  context.goNamed(Settings.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.power_settings_new_sharp),
                title: const Text('Logout'),
                onTap: () {
                  context.goNamed(AuthScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
