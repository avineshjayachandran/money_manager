import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/category/income_category_list.dart';
import 'package:money_manager/model/category/category_model.dart';

const CATEGORY_DB_NAME = 'category_database';

abstract class categoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deletecategory(String categoryID);
}

class CategoryDB implements categoryDbFunctions {
  CategoryDB.internal();

  static CategoryDB instance = CategoryDB.internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> IncomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> ExpenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _CategoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _CategoryDB.put(value.id,value);
   await refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
     print('Fetched Categories: $_allCategories');

    IncomeCategoryListNotifier.value.clear();
    ExpenseCategoryListNotifier.value.clear();

    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          IncomeCategoryListNotifier.value.add(category);
        } else {
          ExpenseCategoryListNotifier.value.add(category);
        }
      },
    );

     print('Income Categories: ${IncomeCategoryListNotifier.value}');
    print('Expense Categories: ${ExpenseCategoryListNotifier.value}');


    IncomeCategoryListNotifier.notifyListeners();
    ExpenseCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> deletecategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI(); 
  }
}
