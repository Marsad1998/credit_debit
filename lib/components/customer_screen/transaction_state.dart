import 'package:flutter/foundation.dart';
import 'package:credit_debit/models/transactions.dart';

class TransactionData extends ChangeNotifier {
  List<Map<String, dynamic>> _transaction = [];
  double _totalPaid = 0;
  double _totalReceived = 0;
  double _totalBalance = 0;

  List<Map<String, dynamic>> get transaction => _transaction;
  double get totalBalance => _totalBalance;
  double get totalPaid => _totalPaid;
  double get totalReceived => _totalReceived;

  Future<void> refreshTransactions(customerId) async {
    final List<Map<String, dynamic>> data;
    if (customerId == null) {
      data = await Transactions.getTransactions(null);
    } else {
      data = await Transactions.getTransactions(customerId);
    }
    _transaction = data;
    notifyListeners();
  }

  Future<void> refreshBalance(customerId) async {
    final List<Map<String, Object?>> data;
    if (customerId == null) {
      data = await Transactions.getTransactionSums(null);
    } else {
      data = await Transactions.getTransactionSums(customerId);
    }
    _totalPaid = (data[0]['total_paid'] as double?) ?? 0.0;
    _totalReceived = (data[0]['total_received'] as double?) ?? 0.0;
    _totalBalance = _totalReceived - _totalPaid;

    notifyListeners();
  }
}
