import 'package:credit_debit/models/customer.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:credit_debit/views/db_connect.dart';

class CustomerService {
  static Future<int> createCustomer(Customer customer) async {
    final db = await SQLHelper.db();

    final data = {'name': customer.name, 'phone': customer.phone};
    final id = await db.insert('customers', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await SQLHelper.db();
    return db.query('customers', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getCustomer(int id) async {
    final db = await SQLHelper.db();
    return db.query('customers', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateCustomer(Customer customer) async {
    final db = await SQLHelper.db();

    final data = {
      'name': customer.name,
      'phone': customer.phone,
      'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('customers', data, where: "id = ?", whereArgs: [customer.id]);
    return result;
  }

  static Future<void> deleteCustomer(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("customers", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
