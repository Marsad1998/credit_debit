import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credit_debit/utils/router.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/viewmodels/customer_state.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';

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
        ChangeNotifierProvider(create: (_) => CustomerState()),
        ChangeNotifierProvider(create: (_) => TransactionState()),
      ],
      child: MaterialApp.router(
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
        routerConfig: MyRoutes.routes,
      ),
    );
  }
}
