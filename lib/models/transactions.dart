import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:credit_debit/db_connect.dart';

class Transactions {
  static Color? balanceColor(balance) {
    if (balance > 0) {
      return Colors.green[800];
    } else if (balance < 0) {
      return Colors.red[600];
    } else {
      return Colors.black;
    }
  }

  static Future<int> createTransaction({
    required double? paid,
    required double? received,
    required String note,
    required String dueDate,
    required String date,
    required int customerId,
  }) async {
    final db = await SQLHelper.db();

    final data = {
      'paid': paid,
      'received': received,
      'note': note,
      'dueDate': dueDate,
      'date': date,
      'customer_id': customerId,
      'createdAt': DateTime.now().toString(),
    };
    final id = await db.insert('transactions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getTransactions(customerId) async {
    final db = await SQLHelper.db();
    if (customerId != null) {
      // Query for a specific customer when customerId is provided
      return db.query('transactions',
          where: "customer_id = ?",
          whereArgs: [customerId],
          orderBy: "createdAt");
    } else {
      // Query all transactions when customerId is null
      return db.query('transactions', orderBy: "createdAt");
    }
  }

  static Future<List<Map<String, Object?>>> getTransactionSums(
      int? customerId) async {
    final db = await SQLHelper.db();

    final List<Map<String, Object?>> result;
    if (customerId == null) {
      result = await db.rawQuery('''
      SELECT SUM(paid) as total_paid, SUM(received) as total_received
      FROM transactions
    ''');
    } else {
      result = await db.rawQuery('''
      SELECT SUM(paid) as total_paid, SUM(received) as total_received
      FROM transactions
      WHERE customer_id = ?
    ''', [customerId]);
    }

    return result.toList();
  }

  static Future<List<Map<String, dynamic>>> getTransaction(int id) async {
    final db = await SQLHelper.db();
    return db.query('transactions', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateTransaction({
    required int id,
    required double? paid,
    required double? received,
    required String note,
    required String dueDate,
    required String date,
    required int customerId,
  }) async {
    final db = await SQLHelper.db();

    final data = {
      'paid': paid,
      'received': received,
      'note': note,
      'dueDate': dueDate,
      'date': date,
      'customer_id': customerId,
    };

    final result =
        await db.update('transactions', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("transactions", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
