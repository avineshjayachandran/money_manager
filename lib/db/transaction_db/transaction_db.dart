import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/model/transaction/transaction_model.dart';

const TRANSACTION_DB = 'transaction_name';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB.internal();
  static TransactionDB instance = TransactionDB.internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> TransactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _db.put(obj.id, obj);
    await Refresh();
  }

  Future<void> Refresh() async {
    final _list = await getTransactions();
    _list.sort((a, b) => b.date.compareTo(a.date));
    TransactionListNotifier.value.clear();
    TransactionListNotifier.value.addAll(_list);
    TransactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _db.delete(id);
    Refresh();
  }
}
