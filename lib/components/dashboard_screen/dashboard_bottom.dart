import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/widgets/summary_buttons.dart';
import 'package:credit_debit/components/dashboard_screen/add_customer.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';

class DashboardBottom extends StatefulWidget {
  const DashboardBottom({
    super.key,
    required this.parentContext,
    this.isShow = true,
  });

  final BuildContext parentContext;
  final bool isShow;

  @override
  State<DashboardBottom> createState() => _DashboardBottomState();
}

class _DashboardBottomState extends State<DashboardBottom> {
  // this ensure that on app start load the global balance
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionState>(context, listen: false).refreshBalance(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kScaffoldColor,
      child: Column(
        children: [
          if (widget.isShow)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                        onPressed: () {
                          context.pushNamed(
                            'show_transactions',
                            extra: {},
                          );
                        },
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
                        child: const Text('Export Report'),
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
                            isScrollControlled: true,
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
          Consumer<TransactionState>(
            builder: (builder, transData, child) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SummaryDiv(
                        label: 'Paid',
                        amount: transData.totalPaidF(0).toStringAsFixed(2),
                        colour: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: SummaryDiv(
                        label: 'Received',
                        amount: transData.totalReceivedF(0).toStringAsFixed(2),
                        colour: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: SummaryDiv(
                        label: 'Balance',
                        amount: transData.totalBalanceF(0).toStringAsFixed(2),
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
