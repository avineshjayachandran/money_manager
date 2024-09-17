import 'package:flutter/material.dart';

import '../db/category_db/category_db.dart';
import '../model/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().IncomeCategoryListNotifier,
        builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final category = newlist[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: ListTile(
                      tileColor: const Color.fromRGBO(60, 59, 61, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: Text(
                        category.name,
                        style:
                            TextStyle(color: Color.fromRGBO(232, 206, 77, 1.0)),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            CategoryDB.instance.deletecategory(category.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(232, 206, 77, 1.0),
                          )),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newlist.length);
        });
  }
}
