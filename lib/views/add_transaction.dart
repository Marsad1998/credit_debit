import 'package:credit_debit/models/transactions.dart';
import 'package:credit_debit/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/widgets/trans_field.dart';
import 'package:credit_debit/services/transaction_services.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';
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
  final _formKey = GlobalKey<FormState>();
  DateTime _todate = DateTime.now();
  DateTime _dueDate = DateTime.now();
  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    Provider.of<TransactionState>(context, listen: false)
        .refreshBalance(widget.customer['id']);

    if (widget.transaction != null) {
      _todate = (widget.transaction?['date'] != null
          ? DateTime.tryParse(widget.transaction!['date'])
          : DateTime.now())!;
      _dueDate = (widget.transaction?['dueDate'] != null
          ? DateTime.tryParse(widget.transaction!['dueDate'])
          : DateTime.now())!;
    }

    // Initialize the controllers here
    double? paidA = widget.transaction?['paid'];
    double? receivedA = widget.transaction?['received'];
    String? notes = widget.transaction?['note'];

    amountController = TextEditingController(
      text: (paidA != null && paidA > 0)
          ? paidA.toStringAsFixed(2)
          : (receivedA != null ? receivedA.toStringAsFixed(2) : ''),
    );

    noteController = TextEditingController(
      text: (notes != null && notes.isNotEmpty) ? notes : '',
    );
  }

  void reloadProvider() {
    final transDataProvider =
        Provider.of<TransactionState>(context, listen: false);
    transDataProvider.refreshTransactions(widget.customer['id']);
    transDataProvider.refreshBalance(widget.customer['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionState>(
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
                    await TransactionService.deleteTransaction(
                        widget.transaction?['id']);
                    reloadProvider();
                    if (!context.mounted) return; // very important
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
                            transData
                                .totalBalanceF(widget.customer['id'])
                                .toStringAsFixed(2),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\-?\d+\.?\d*'),
                          ), // Allow integers and decimals, including negative values
                        ],
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
                              Transaction trans = Transaction(
                                paid: widget.type == 'Paid' ? amount! : 0,
                                received:
                                    widget.type == 'Received' ? amount! : 0,
                                dueDate: _dueDate.toString(),
                                date: _todate.toString(),
                                customerId: widget.customer['id'],
                                note: noteController.text,
                              );
                              await TransactionService.createTransaction(trans);
                            } else {
                              Transaction trans = Transaction(
                                paid: widget.type == 'Paid' ? amount! : 0,
                                received:
                                    widget.type == 'Received' ? amount! : 0,
                                dueDate: _dueDate.toString(),
                                date: _todate.toString(),
                                customerId: widget.customer['id'],
                                note: noteController.text,
                                id: widget.transaction?['id'],
                              );
                              await TransactionService.updateTransaction(trans);
                            }

                            reloadProvider();
                            if (!context.mounted) return; // very important
                            Notifications.showNotification(
                                context, 'Transaction Saved Successfully');
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
