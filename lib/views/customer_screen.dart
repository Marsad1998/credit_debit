import 'dart:io';
import 'package:credit_debit/components/customer_screen/customer_bottom.dart';
import 'package:credit_debit/components/customer_screen/show_transactions.dart';
import 'package:credit_debit/services/pdf_services.dart';
import 'package:credit_debit/services/transaction_services.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key, required this.customer});
  final Map<String, dynamic> customer;
  static String id = 'customer_screen';

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World'),
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? data) {
        final provider = Provider.of<TransactionState>(context, listen: false);
        provider.refreshBalance(null);
      },
      child: Scaffold(
        backgroundColor: kScaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          title: Text(customer['name']),
          actions: [
            IconButton(
                onPressed: () async {
                  List<Map<String, dynamic>> transactions =
                      await TransactionService.getTransactions(customer['id']);

                  final pdfView = await PdfServices.allTransactionPdf(
                      transactions, customer['name'], 'All Transactions');
                  PdfServices.openPdf(pdfView);
                },
                icon: const Icon(Icons.picture_as_pdf))
          ],
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
                child:
                    CustomerBottom(parentContext: context, customer: customer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
