import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfServices {
  static Future<File> savePdf(
      {required String name, required Document pdf}) async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final file = File('${root!.path}/$name');
    await file.writeAsBytes(await pdf.save());
    debugPrint('${root.path}/$name');
    return file;
  }

  static Future<void> openPdf(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }

  static Future<File> allTransactionPdf(List<Map<String, dynamic>> transactions,
      String name, String dateTimeRange) async {
    final pdf = Document();

    pdf.addPage(
      Page(
        build: (context) => transactionTbl(transactions, name, dateTimeRange),
      ),
    );

    return savePdf(name: name, pdf: pdf);
  }

  static Widget transactionTbl(List<Map<String, dynamic>> transactions,
      String name, String dateTimeRange) {
    double totalPaid = 0;
    double totalReceived = 0;
    double balance = 0;

    String dateFormat(date) =>
        DateFormat('dd/MM/yyyy').format(DateTime.parse(date));

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            dateTimeRange,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      Table(
        border: TableBorder.all(),
        children: [
          // Header row
          TableRow(
            children: [
              pdfTableCell('No.', true),
              pdfTableCell('Paid', true),
              pdfTableCell('Received', true),
              pdfTableCell('Note', true),
              pdfTableCell('Date', true),
            ],
          ),
          // Data rows
          ...transactions.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> transaction = entry.value;
            totalPaid += transaction['paid'];
            totalReceived += transaction['received'];
            balance = (transaction['received'] - transaction['paid']) + balance;
            return TableRow(
              children: [
                pdfTableCell((index + 1).toString(), false),
                pdfTableCell(dateFormat(transaction['date']), false),
                pdfTableCell(transaction['paid'].toString(), false),
                pdfTableCell(transaction['received'].toString(), false),
                pdfTableCell(balance.toString(), false),
              ],
            );
          }),
          TableRow(
            children: [
              pdfTableCell('', false),
              pdfTableCell('Total', false),
              pdfTableCell(totalPaid.toString(), true),
              pdfTableCell(totalReceived.toString(), true),
              pdfTableCell((totalReceived - totalPaid).toString(), true),
            ],
          ),
        ],
      )
    ]);
  }

  // Helper method to create PDF table cells
  static Widget pdfTableCell(String content, bool isBold) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        content,
        style:
            TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
