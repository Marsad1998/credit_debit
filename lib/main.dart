import 'package:credit_debit/components/customer/transaction_state.dart';
import 'package:credit_debit/components/dashboard/customer_state.dart';
import 'package:credit_debit/constants.dart';
import 'package:credit_debit/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerData()),
        ChangeNotifierProvider(create: (_) => TransactionData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlueAccent,
          ),
          datePickerTheme: const DatePickerThemeData(
            dividerColor: Colors.blue,
            shadowColor: Colors.blue,
            elevation: 15,
            headerBackgroundColor: Colors.lightBlueAccent,
            backgroundColor: kScaffoldColor,
            headerForegroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const DashboardScreen(title: 'Credit Debit'),
      ),
    );
  }
}
