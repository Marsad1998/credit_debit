import 'package:credit_debit/services/customer_services.dart';
import 'package:flutter/foundation.dart';

class CustomerState extends ChangeNotifier {
  List<Map<String, dynamic>> _customers = [];

  List<Map<String, dynamic>> get customers => _customers;

  // Method to load customers from database
  Future<void> refreshCustomers() async {
    final data = await CustomerService.getCustomers();
    _customers = data;
    notifyListeners(); // Notify listeners to rebuild UI when data is loaded
  }
}
