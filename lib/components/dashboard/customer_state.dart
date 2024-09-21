import 'package:credit_debit/models/customers.dart';
import 'package:flutter/foundation.dart';

class CustomerData extends ChangeNotifier {
  List<Map<String, dynamic>> _customers = [];

  List<Map<String, dynamic>> get customers => _customers;

  // Method to load customers from database
  Future<void> refreshCustomers() async {
    final data = await Customers.getItems();
    _customers = data;
    notifyListeners(); // Notify listeners to rebuild UI when data is loaded
  }
}
