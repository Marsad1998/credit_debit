import 'package:credit_debit/components/customer/transaction_state.dart';
import 'package:credit_debit/components/dashboard/add_customer.dart';
import 'package:credit_debit/widgets/summary_buttons.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/constants.dart';
import 'package:provider/provider.dart';

class DashboardBottom extends StatefulWidget {
  const DashboardBottom({
    super.key,
    required this.parentContext,
  });

  final BuildContext parentContext;

  @override
  State<DashboardBottom> createState() => _DashboardBottomState();
}

class _DashboardBottomState extends State<DashboardBottom> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionData>(context, listen: false).refreshBalance(null);
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
                      onPressed: () {},
                      style: kDefaultButton.copyWith(
                        foregroundColor:
                            WidgetStatePropertyAll(Colors.blue[900]),
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.lightBlue[100],
                        ),
                        shadowColor: WidgetStatePropertyAll(
                          Colors.lightBlue[100],
                        ),
                      ),
                      child: const Text('Transactions'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      style: kDefaultButton,
                      onPressed: () {
                        showModalBottomSheet(
                          context: widget.parentContext,
                          builder: (builder) => Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(widget.parentContext)
                                    .viewInsets
                                    .bottom),
                            child: const SingleChildScrollView(
                              child: AddCustomer(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Add Customers'),
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
