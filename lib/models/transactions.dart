import 'package:flutter/material.dart';

class Transaction {
  final double paid;
  final double received;
  final String? note;
  final String dueDate;
  final String date;
  final int customerId;
  final int? id;

  Transaction(
      {required this.paid,
      required this.received,
      this.note,
      required this.dueDate,
      required this.date,
      required this.customerId,
      this.id});

  static Color? balanceColor(balance) {
    if (balance > 0) {
      return Colors.green[800];
    } else if (balance < 0) {
      return Colors.red[600];
    } else {
      return Colors.black;
    }
  }
}
