import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:credit_debit/views/db_connect.dart';
import 'package:credit_debit/models/transactions.dart';

class TransactionService {
  static Future<int> createTransaction(Transaction transaction) async {
    final db = await SQLHelper.db();

    final data = {
      'paid': transaction.paid,
      'received': transaction.received,
      'note': transaction.note,
      'dueDate': transaction.dueDate,
      'date': transaction.date,
      'customer_id': transaction.customerId,
      'createdAt': DateTime.now().toString(),
    };
    final id = await db.insert('transactions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getTransactions(
    int? customerId, {
    DateTimeRange? dateTimeRange,
  }) async {
    final db = await SQLHelper.db();
    String whereClause = "";
    List<String> whereArgs = [];

    // Check if customerId is provided
    if (customerId != null) {
      whereClause += "customer_id = ?";
      whereArgs.add(customerId.toString());
    }

    // Check if dateTimeRange is provided
    if (dateTimeRange != null) {
      if (whereClause.isNotEmpty) {
        whereClause += " AND ";
      }
      whereClause += "date BETWEEN ? AND ?";
      whereArgs.addAll([
        dateTimeRange.start.toIso8601String(),
        dateTimeRange.end.toIso8601String(),
      ]);
    }

    // If whereClause is empty, fetch all transactions
    return db.query(
      'transactions',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereClause.isEmpty ? null : whereArgs,
      orderBy: customerId != null ? "date" : "createdAt",
    );
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

  static Future<int> updateTransaction(Transaction transaction) async {
    final db = await SQLHelper.db();

    final data = {
      'paid': transaction.paid,
      'received': transaction.received,
      'note': transaction.note,
      'dueDate': transaction.dueDate,
      'date': transaction.date,
      'customer_id': transaction.customerId,
    };

    final result = await db.update('transactions', data,
        where: "id = ?", whereArgs: [transaction.id]);
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

  static Future<void> deleteCustomerTransaction(int id) async {
    final db = await SQLHelper.db();
    try {
      await db
          .delete("transactions", where: "customer_id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
