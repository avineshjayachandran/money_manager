import 'package:flutter/material.dart';
import 'package:money_manager/category/expense_categoty_list.dart';
import 'package:money_manager/category/income_category_list.dart';
import 'package:money_manager/db/category_db/category_db.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(179, 179, 179, 1),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              indicatorColor: const Color.fromRGBO(60, 59, 61, 1),
              labelColor: Color.fromRGBO(60, 59, 61, 1),
              unselectedLabelColor: Color.fromRGBO(135, 144, 133, 1),
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text(
                    'INCOME',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'EXPENSE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: const [
                IncomeCategoryList(),
                ExpenseCategoryList()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
