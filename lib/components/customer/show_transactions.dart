import 'package:credit_debit/constants.dart';
import 'package:credit_debit/models/transactions.dart';
import 'package:credit_debit/screens/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:credit_debit/components/customer/transaction_state.dart';
import 'package:sqflite/sqflite.dart';

class ShowTransactions extends StatefulWidget {
  const ShowTransactions({
    super.key,
    required this.customer,
  });

  final Map<String, dynamic> customer;

  @override
  State<ShowTransactions> createState() => _ShowTransactionsState();
}

class _ShowTransactionsState extends State<ShowTransactions> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionData>(context, listen: false)
        .refreshTransactions(widget.customer['id']);
  }

  double balance = 0;
  double totalPaid = 0;
  double totalReceived = 0;
  double calculateBalance(paid, received) {
    totalPaid += paid;
    totalReceived += received;
    balance = (received - paid) + balance;
    return balance;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionData>(
      builder: (context, transData, child) {
        balance = 0;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey[200],
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Received',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Paid',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red[600], fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Balance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transData.transaction.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (builder, index) {
                  final trans = transData.transaction[index];
                  final DateTime createdAt = DateTime.parse(trans['createdAt']);
                  final String formattedDate =
                      DateFormat('dd MMMM yyyy EEEE (h:mm a)')
                          .format(createdAt);
                  double totalBalance =
                      calculateBalance(trans['paid'], trans['received']);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => AddTransaction(
                            customer: widget.customer,
                            transaction: transData.transaction[index],
                            type: trans['received'] > 0 ? 'Received' : 'Paid',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 16.0),
                      margin: const EdgeInsets.symmetric(vertical: 2.5),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(formattedDate),
                              ),
                              Expanded(
                                child: Text(
                                  trans['received'] > 0
                                      ? trans['received'].toStringAsFixed(2)
                                      : '',
                                  style: TextStyle(color: Colors.green[800]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  trans['paid'] > 0
                                      ? trans['paid'].toStringAsFixed(2)
                                      : '',
                                  style: TextStyle(color: Colors.red[600]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  totalBalance.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Transactions.balanceColor(totalBalance),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (trans['note'] != null &&
                              trans['note'].toString().isNotEmpty)
                            Text(
                              trans['note'],
                              style: TextStyle(
                                color: Colors.redAccent[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
