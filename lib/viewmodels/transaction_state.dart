import 'package:flutter/foundation.dart';
import 'package:credit_debit/services/transaction_services.dart';

class TransactionState extends ChangeNotifier {
  List<Map<String, dynamic>> _transaction = [];

  final Map<int, double> _totalPaidMap = {};
  final Map<int, double> _totalReceivedMap = {};
  final Map<int, double> _totalBalanceMap = {};

  List<Map<String, dynamic>> get transaction => _transaction;

  double totalPaidF(int customerId) => _totalPaidMap[customerId] ?? 0.0;
  double totalReceivedF(int customerId) => _totalReceivedMap[customerId] ?? 0.0;
  double totalBalanceF(int customerId) => _totalBalanceMap[customerId] ?? 0.0;

  Future<void> refreshTransactions(customerId) async {
    final List<Map<String, dynamic>> data;
    if (customerId == null) {
      data = await TransactionService.getTransactions(null);
    } else {
      data = await TransactionService.getTransactions(customerId);
    }
    _transaction = data;
    notifyListeners();
  }

  Future<void> refreshBalance(customerId) async {
    final List<Map<String, Object?>> data;
    if (customerId == null) {
      // print('of');
      data = await TransactionService.getTransactionSums(null);

      _totalPaidMap[0] = (data[0]['total_paid'] as double?) ?? 0.0;
      _totalReceivedMap[0] = (data[0]['total_received'] as double?) ?? 0.0;
      _totalBalanceMap[0] = _totalReceivedMap[0]! - _totalPaidMap[0]!;
    } else {
      data = await TransactionService.getTransactionSums(customerId);

      _totalPaidMap[customerId] = (data[0]['total_paid'] as double?) ?? 0.0;
      _totalReceivedMap[customerId] =
          (data[0]['total_received'] as double?) ?? 0.0;
      _totalBalanceMap[customerId] =
          _totalReceivedMap[customerId]! - _totalPaidMap[customerId]!;
    }

    notifyListeners();
  }
}
