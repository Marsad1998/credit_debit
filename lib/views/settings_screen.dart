import 'package:credit_debit/services/auth_services.dart';
import 'package:credit_debit/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  static const String id = 'settings';
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDevice = true;
  late TextEditingController pinController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Check if the user has already set up a PIN
    final hasPin = await AuthService().hasSetupPin();
    isDevice = hasPin;
    pinController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Remember Device'),
                Checkbox(
                    value: true,
                    onChanged: (value) {
                      setState(() {
                        isDevice = value!;
                      });
                    })
              ],
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Your Pin'),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                suffixIcon: Icon(Icons.remove_red_eye),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white),
              child: const Text('Update Pin'),
            )
          ],
        ),
      )),
    );
  }
}
