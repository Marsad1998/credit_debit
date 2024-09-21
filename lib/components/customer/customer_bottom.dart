import 'package:credit_debit/components/customer/transaction_state.dart';
import 'package:credit_debit/models/transactions.dart';
import 'package:credit_debit/screens/add_transaction.dart';
import 'package:credit_debit/widgets/summary_buttons.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/constants.dart';
import 'package:provider/provider.dart';

class CustomerBottom extends StatefulWidget {
  const CustomerBottom({
    super.key,
    required this.parentContext,
    required this.customer,
  });

  final BuildContext parentContext;
  final Map<String, dynamic> customer;

  @override
  State<CustomerBottom> createState() => _CustomerBottomState();
}

class _CustomerBottomState extends State<CustomerBottom> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionData>(context, listen: false)
        .refreshBalance(widget.customer['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kScaffoldColor,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => AddTransaction(
                                customer: widget.customer, type: 'Received'),
                          ),
                        );
                      },
                      style: kDefaultButton.copyWith(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.green,
                        ),
                        shadowColor: const WidgetStatePropertyAll(
                          Colors.green,
                        ),
                      ),
                      child: const Text('You Received'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      style: kDefaultButton.copyWith(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.redAccent,
                        ),
                        shadowColor: WidgetStatePropertyAll(
                          Colors.redAccent[100],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => AddTransaction(
                                customer: widget.customer, type: 'Paid'),
                          ),
                        );
                      },
                      child: const Text('You Paid'),
                    ),
                  ),
                )
              ],
            ),
          ),
          Consumer<TransactionData>(
            builder: (builder, transData, child) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SummaryDiv(
                        label: 'Paid',
                        amount: transData.totalPaid.toStringAsFixed(2),
                        colour: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: SummaryDiv(
                        label: 'Received',
                        amount: transData.totalReceived.toStringAsFixed(2),
                        colour: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: SummaryDiv(
                        label: 'Balance',
                        amount: transData.totalBalance.toStringAsFixed(2),
                        colour: Colors.black,
                        txtcolour:
                            Transactions.balanceColor(transData.totalBalance),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
