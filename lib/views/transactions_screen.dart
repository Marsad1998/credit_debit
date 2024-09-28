import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/components/dashboard_screen/dashboard_bottom.dart';
import 'package:credit_debit/components/transactions_screen/all_transactions.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key, required this.title});
  static const String id = 'show_transactions';

  final String title;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final pdf = pw.Document();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 9,
              child: AllTransactions(),
            ),
            Expanded(
              child: DashboardBottom(
                parentContext: context,
                isShow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
