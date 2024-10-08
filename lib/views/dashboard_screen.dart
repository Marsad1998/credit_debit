import 'package:credit_debit/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/components/dashboard_screen/dashboard_bottom.dart';
import 'package:credit_debit/components/dashboard_screen/show_customer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.title});

  final String title;
  static String id = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ShowCustomers(parentContext: context),
            ),
            Expanded(
              child: DashboardBottom(parentContext: context),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
