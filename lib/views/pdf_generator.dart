import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:credit_debit/services/pdf_services.dart';
import 'package:credit_debit/services/customer_services.dart';
import 'package:credit_debit/services/transaction_services.dart';

class PdfGenerator extends StatefulWidget {
  const PdfGenerator({super.key});

  @override
  State<PdfGenerator> createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? selectedCustomer; // To store the selected customer
  String? selectedName = 'All Customers';
  late DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month,
        1), // Start of the current month
    end: DateTime(DateTime.now().year, DateTime.now().month + 1,
        0), // Last day of the current month
  );

  String _dateFormat(date) =>
      DateFormat('dd/MM/yyyy').format(DateTime.parse(date));

  Widget tableCellContent(data, bool style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2),
      child: Text(data,
          style: TextStyle(fontWeight: style ? FontWeight.bold : null)),
    );
  }

  Future<List<Map<String, dynamic>>> filterTransaction(
      int? customerId, DateTimeRange? dateTimeRange) {
    if (customerId != null && dateTimeRange != null) {
      // If both customerId and dateTimeRange are provided
      return TransactionService.getTransactions(
        customerId,
        dateTimeRange: dateTimeRange,
      );
    } else if (customerId != null) {
      // If only customerId is provided
      return TransactionService.getTransactions(customerId);
    } else if (dateTimeRange != null) {
      // If only dateTimeRange is provided
      return TransactionService.getTransactions(
        null,
        dateTimeRange: dateTimeRange,
      );
    } else {
      // If neither customerId nor dateTimeRange is provided
      return TransactionService.getTransactions(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: const Text('Transaction Report'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Map<String, dynamic>> transactions = await filterTransaction(
            selectedCustomer == null ? null : int.parse(selectedCustomer!),
            dateTimeRange, // Pass the dateTimeRange here
          );

          final pdfView = await PdfServices.allTransactionPdf(
              transactions,
              selectedName!,
              '${_dateFormat(dateTimeRange.start.toString())} - ${_dateFormat(dateTimeRange.end.toString())}');
          PdfServices.openPdf(pdfView);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.picture_as_pdf),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: CustomerService.getCustomers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loader while fetching
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching customers');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No customers found');
                  }

                  // Data available, map customers to DropdownMenuItems
                  List<DropdownMenuEntry<String>> customerS =
                      snapshot.data!.map<DropdownMenuEntry<String>>((customer) {
                    return DropdownMenuEntry<String>(
                      value: customer['id']
                          .toString(), // Use the customer ID as the value
                      label:
                          customer['name'], // Use the customer name for display
                    );
                  }).toList();

                  return DropdownMenu(
                    hintText: 'Select Customer',
                    initialSelection: selectedCustomer,
                    dropdownMenuEntries: customerS,
                    width: double.infinity,
                    requestFocusOnTap: true,
                    onSelected: (value) {
                      setState(() {
                        selectedCustomer = value;
                        selectedName = snapshot.data!.firstWhere((customer) =>
                            customer['id'].toString() == value)['name'];
                      });
                    },
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                ),
                onPressed: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDateRange: dateTimeRange,
                  );

                  setState(() {
                    dateTimeRange = picked!;
                    startDate = picked.start;
                    endDate = picked.end;
                  });
                },
                child: Text(
                  'Date: ${_dateFormat(dateTimeRange.start.toString())} - ${_dateFormat(dateTimeRange.end.toString())}',
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                flex: 9,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: filterTransaction(
                    selectedCustomer == null
                        ? null
                        : int.parse(selectedCustomer!),
                    dateTimeRange, // Pass the dateTimeRange here
                  ), // Fetch all transactions
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No transactions found'));
                    }

                    final transactions = snapshot.data!;

                    double totalPaid = 0;
                    double totalReceived = 0;
                    double balance = 0;
                    return Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(30),
                      },
                      children: [
                        // Add the header row
                        TableRow(
                          children: [
                            tableCellContent('#', true),
                            tableCellContent('Date', true),
                            tableCellContent('Paid', true),
                            tableCellContent('Received', true),
                            tableCellContent('Balance', true),
                          ],
                        ),
                        // Dynamically add rows based on transaction data
                        ...transactions.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> transaction = entry.value;
                          totalPaid += transaction['paid'];
                          totalReceived += transaction['received'];
                          balance =
                              (transaction['received'] - transaction['paid']) +
                                  balance;
                          return TableRow(
                            children: [
                              tableCellContent((index + 1).toString(), false),
                              tableCellContent(
                                  _dateFormat(transaction['date']), false),
                              tableCellContent(
                                  transaction['paid'].toString(), false),
                              tableCellContent(
                                  transaction['received'].toString(), false),
                              tableCellContent(balance.toString(), false),
                            ],
                          );
                        }),
                        TableRow(
                          children: [
                            tableCellContent('', false),
                            tableCellContent('Total', false),
                            tableCellContent(totalPaid.toString(), true),
                            tableCellContent(totalReceived.toString(), true),
                            tableCellContent(
                                (totalReceived - totalPaid).toString(), true),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
