import 'package:flutter/material.dart';
import 'package:money_manager/category/category_add_screen.dart';
import 'package:money_manager/category/screen_category.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/home/widgets/bottom_navigation.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:money_manager/transaction/screen_transaction.dart';
import 'package:money_manager/transaction/transaction_add_screen.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(179, 179, 179, 1),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          toolbarHeight: 120,
          backgroundColor: const Color.fromRGBO(60, 59, 61, 1),
          title: const Text(
            'MONEY MANAGER',
            style: TextStyle(
                color: Color.fromRGBO(232, 206, 77, 1.0),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, child) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(60, 59, 61, 1),
        onPressed: () {
          if (ScreenHome.selectedIndexNotifier.value == 0) {
           
            showTransactionSheet(context);
             TransactionDB.instance.Refresh();
          } else {
            ShowCatoegorySheet(context);

            // final _sample = CategoryModel(
            //   id: DateTime.now().microsecondsSinceEpoch.toString(),
            //   name: 'travel',
            //   type: CategoryType.expense,
            // );
            // CategoryDB().insertCategory(_sample);
          }
        },
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(232, 206, 77, 1.0),
        ),
      ),
    );
  }
}
