import 'package:credit_debit/components/customer_screen/customer_bottom.dart';
import 'package:credit_debit/components/customer_screen/show_transactions.dart';
import 'package:credit_debit/components/customer_screen/transaction_state.dart';
import 'package:credit_debit/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key, required this.customer});
  final Map<String, dynamic> customer;
  static String id = 'customer_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: Text(customer['name']),
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
