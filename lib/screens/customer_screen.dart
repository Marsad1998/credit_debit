import 'package:credit_debit/components/customer/customer_bottom.dart';
import 'package:credit_debit/components/customer/show_transactions.dart';
import 'package:credit_debit/components/dashboard/show_customer.dart';
import 'package:credit_debit/constants.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key, required this.customer});

  final Map<String, dynamic> customer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: Text(customer['name']),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ShowTransactions(
                customer: customer,
              ),
            ),
            Expanded(
              child: CustomerBottom(parentContext: context, customer: customer),
            ),
          ],
        ),
      ),
    );
  }
}
