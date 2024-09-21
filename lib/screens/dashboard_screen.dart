import 'package:credit_debit/components/dashboard/customer_state.dart';
import 'package:credit_debit/components/dashboard/dashboard_bottom.dart';
import 'package:credit_debit/components/dashboard/show_customer.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/constants.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.title});

  final String title;

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
