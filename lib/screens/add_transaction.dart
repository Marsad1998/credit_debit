import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/constants.dart';
import 'package:credit_debit/widgets/trans_field.dart';
import 'package:credit_debit/models/transactions.dart';
import 'package:credit_debit/components/customer_screen/transaction_state.dart';
import 'package:credit_debit/widgets/my_date_picker.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction(
      {super.key,
      required this.customer,
      required this.type,
      this.transaction});

  final String type;
  static String id = 'transaction_screen';
  final Map<String, dynamic> customer;
  final Map<String, dynamic>? transaction;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime _todate = DateTime.now();
  DateTime _dueDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionData>(context, listen: false)
        .refreshBalance(widget.customer['id']);
  }

  @override
  Widget build(BuildContext context) {
    double? paidA = widget.transaction?['paid'];
    double? receivedA = widget.transaction?['received'];
    String? notes = widget.transaction?['note'];
    final transDataProvider =
        Provider.of<TransactionData>(context, listen: false);

    TextEditingController amountController = TextEditingController(
      text: (paidA != null && paidA > 0)
          ? paidA.toStringAsFixed(2)
          : (receivedA != null ? receivedA.toStringAsFixed(2) : ''),
    );
    TextEditingController noteController = TextEditingController(
      text: (notes != null && notes.isNotEmpty) ? notes : '',
    );
    return Consumer<TransactionData>(
      builder: (builder, transData, child) {
        return Scaffold(
          backgroundColor: kScaffoldColor,
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.white,
            title: const Text('Add Transaction'),
            actions: [
              if (widget.transaction != null)
                IconButton(
                  onPressed: () async {
                    await Transactions.deleteTransaction(
                        widget.transaction?['id']);

                    transDataProvider
                        .refreshTransactions(widget.customer['id']);
                    transDataProvider.refreshBalance(widget.customer['id']);

                    if (!context.mounted) return; // ver important
                    context.pop();
                  },
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.customer['name'],
                        style: kDefaultHead,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            'Balance: ',
                            style: kH2,
                          ),
                          Text(
                            transData.totalBalance.toStringAsFixed(2),
                            style: kH2.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      TransField(
                        autofocus: true,
                        label: 'Amount ${widget.type}',
                        icon: const Icon(Icons.attach_money),
                        controller: amountController,
                        keyBoardType: TextInputType.number,
                        callBackFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount Field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      TransField(
                        minL: 5,
                        label: 'Notes (Optional)',
                        icon: const Icon(Icons.edit_note),
                        controller: noteController,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Date:',
                        style: kH2,
                      ),
                      MyDatePicker(
                        initialDate:
                            _todate, // Set initial date for the first picker
                        onDateSelected: (date) {
                          setState(() {
                            _todate =
                                date; // Update the selected date for the first picker
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Due Date:',
                        style: kH2,
                      ),
                      MyDatePicker(
                        initialDate:
                            _dueDate, // Set initial date for the first picker
                        onDateSelected: (date) {
                          setState(() {
                            _dueDate =
                                date; // Update the selected date for the first picker
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          double? amount =
                              double.tryParse(amountController.text);
                          if (_formKey.currentState!.validate()) {
                            if (widget.transaction == null) {
                              await Transactions.createTransaction(
                                customerId: widget.customer['id'],
                                paid: widget.type == 'Paid' ? amount : 0,
                                received:
                                    widget.type == 'Received' ? amount : 0,
                                note: noteController.text,
                                dueDate: _dueDate.toString(),
                                date: _todate.toString(),
                              );
                            } else {
                              await Transactions.updateTransaction(
                                id: widget.transaction?['id'],
                                customerId: widget.customer['id'],
                                paid: widget.type == 'Paid' ? amount : 0,
                                received:
                                    widget.type == 'Received' ? amount : 0,
                                note: noteController.text,
                                dueDate: _dueDate.toString(),
                                date: _todate.toString(),
                              );
                            }

                            transDataProvider
                                .refreshTransactions(widget.customer['id']);

                            transDataProvider
                                .refreshBalance(widget.customer['id']);

                            if (!context.mounted) return; // ver important
                            context.pop();
                          }
                        },
                        style: kDefaultButton,
                        child: const Text('Save'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
