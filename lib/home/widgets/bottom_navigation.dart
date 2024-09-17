import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/category/expense_categoty_list.dart';
import 'package:money_manager/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 80,
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndexNotifier,
          builder: (BuildContext ctx, int updatedIndex, Widget? _) {
            return BottomNavigationBar(
                currentIndex: updatedIndex,
                onTap: (newIndex) {
                  ScreenHome.selectedIndexNotifier.value = newIndex;
                },
                backgroundColor: const Color.fromRGBO(60, 59, 61, 1),
                selectedItemColor: const Color.fromRGBO(232, 206, 77, 1.0),
                unselectedItemColor: const Color.fromRGBO(198, 190, 168, 1.0),
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                      ),
                      label: 'Transactions'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.category,
                        size: 30,
                      ),
                      label: 'Category'),
                ]);
          },
        ),
      ),
    );
  }
}
