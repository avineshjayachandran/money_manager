import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:money_manager/model/transaction/transaction_model.dart';

DateTime? _selectedDate;
CategoryType? _selectedCategoryType;
CategoryModel? _selectedCategoryModel;

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

ValueNotifier<DateTime?> selecteddateNotifier = ValueNotifier<DateTime?>(null);

ValueNotifier<String?> SelectedCategoryIdNotifier =
    ValueNotifier<String?>(null);

final _purposeTextEditingController = TextEditingController();
final _amountTextEditingController = TextEditingController();

Future<void> addTransaction(BuildContext context) async {
  final _purposeText = _purposeTextEditingController.text;
  final _amountText = _amountTextEditingController.text;

  // Logging for debugging
  print('Purpose: $_purposeText');
  print('Amount: $_amountText');
  print('Selected Date: $_selectedDate');
  print('Selected Category: $_selectedCategoryModel');
  print('Selected Category Type: $_selectedCategoryType');

  if (_purposeText.isEmpty ||
      _amountText.isEmpty ||
      _selectedDate == null ||
      _selectedCategoryModel == null) {
    print('Validation failed: One of the required fields is null.');
    // Show an error message or return
    return;
  }

  final _parseAmount = double.tryParse(_amountText);

  if (_parseAmount == null) {
    print('Amount Parsing failed');
    return;
  }

  final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parseAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!);

  await TransactionDB.instance.addTransaction(_model);

_purposeTextEditingController.clear();
  _amountTextEditingController.clear();
  _selectedDate = null;
  _selectedCategoryModel = null;
  selecteddateNotifier.value = null;
  SelectedCategoryIdNotifier.value = null;

  // Reset the radio button to default (Income)
  _selectedCategoryType = CategoryType.income;
  selectedCategoryNotifier.value = CategoryType.income;



  Navigator.of(context).pop();
  TransactionDB.instance.Refresh();
}

Future<void> showTransactionSheet(BuildContext context) async {
  _selectedCategoryType = CategoryType.income;
  selectedCategoryNotifier.value = _selectedCategoryType!;

  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    backgroundColor: const Color.fromRGBO(60, 59, 61, 1),
    context: context,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _purposeTextEditingController,
              style: const TextStyle(color: Color.fromRGBO(232, 206, 77, 1.0)),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(232, 206, 77, 1.0), width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Enter transaction',
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(232, 206, 77, 1.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _amountTextEditingController,
              style: const TextStyle(color: Color.fromRGBO(232, 206, 77, 1.0)),
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(232, 206, 77, 1.0), width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter payment',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(232, 206, 77, 1.0),
                ),
              ),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 60)),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now());

                if (_selectedDateTemp != null) {
                  _selectedDate = _selectedDateTemp;
                  selecteddateNotifier.value = _selectedDateTemp;
                }
              },
              label: ValueListenableBuilder<DateTime?>(
                  valueListenable: selecteddateNotifier,
                  builder: (BuildContext context, DateTime? value, Widget? _) {
                    String formattedDate = value != null
                        ? DateFormat('dd-MM-yy').format(value)
                        : 'Select Date';
                    return Text(
                      formattedDate,
                      style: const TextStyle(
                          color: Color.fromRGBO(232, 206, 77, 1.0)),
                    );
                  }),
              icon: const Icon(
                Icons.calendar_today_rounded,
                color: Color.fromRGBO(232, 206, 77, 1.0),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ValueListenableBuilder<CategoryType>(
                valueListenable: selectedCategoryNotifier,
                builder: (BuildContext ctx, CategoryType selectedCategory,
                    Widget? _) {
                  final categories = selectedCategory == CategoryType.income
                      ? CategoryDB().IncomeCategoryListNotifier.value
                      : CategoryDB().ExpenseCategoryListNotifier.value;

                  return categories.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ValueListenableBuilder<String?>(
                            valueListenable: SelectedCategoryIdNotifier,
                            builder: (context, selectedCategoryid, child) {
                              return DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                232, 206, 77, 1.0),
                                            width: 3))),
                                hint: const Text(
                                  'Select Category',
                                  style: TextStyle(
                                      color: Color.fromRGBO(232, 206, 77, 1.0)),
                                ),
                                value: selectedCategoryid,
                                items: categories.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(
                                      e.name,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(
                                              232, 206, 77, 1.0)),
                                    ),
                                    onTap: () {
                                      _selectedCategoryModel = e;
                                    },
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {
                                  SelectedCategoryIdNotifier.value =
                                      selectedValue;
                                  print(selectedValue);
                                },
                              );
                            },
                          ))
                      : Text('no categories available');
                }),
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    addTransaction(context);
                  },
                  child: const Text('SUBMIT'))),
          SizedBox(height: 20),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder<CategoryType>(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  activeColor: const Color.fromRGBO(232, 206, 77, 1.0),
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    _selectedCategoryType = value;
                    print('Category Type Selected: $_selectedCategoryType');
                    SelectedCategoryIdNotifier.value = null;

                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();
                  });
            }),
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(232, 206, 77, 1.0), fontSize: 16),
        ),
      ],
    );
  }
}
