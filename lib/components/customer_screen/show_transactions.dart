import 'package:credit_debit/models/transactions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/views/add_transaction.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';

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
  void initState() {
    super.initState();

    Provider.of<TransactionState>(context, listen: false)
        .refreshTransactions(widget.customer['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionState>(
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
                  final String timeStamp = DateFormat('EEE, dd MMM yyyy')
                      .format(DateTime.parse(trans['date']));
                  final String dueDate = DateFormat('EEE, dd MMM yyyy')
                      .format(DateTime.parse(trans['dueDate']));
                  final bool isDueDatePassed =
                      DateTime.parse(trans['dueDate']).isBefore(DateTime.now());

                  double totalBalance =
                      calculateBalance(trans['paid'], trans['received']);
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AddTransaction.id,
                        extra: {
                          'customer': widget.customer,
                          'transaction': transData.transaction[index],
                          'type': trans['received'] > 0 ? 'Received' : 'Paid',
                        },
                      );
                    },
                    child: Container(
                      color: Colors.grey[300],
                      margin: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isDueDatePassed)
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[500],
                                ),
                              Text(
                                ' Due Date: $dueDate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          Container(
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(timeStamp),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        trans['received'] > 0
                                            ? trans['received']
                                                .toStringAsFixed(2)
                                            : '',
                                        style:
                                            TextStyle(color: Colors.green[800]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        trans['paid'] > 0
                                            ? trans['paid'].toStringAsFixed(2)
                                            : '',
                                        style:
                                            TextStyle(color: Colors.red[600]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        totalBalance.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Transaction.balanceColor(
                                              totalBalance),
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
