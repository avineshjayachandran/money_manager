import 'package:flutter/material.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/model/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> ShowCatoegorySheet(BuildContext context) async {
  final _nameEditingController = TextEditingController();

  showModalBottomSheet<dynamic>(
    context: context,
    builder: (ctx) {
      return Wrap(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(60, 59, 61, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: const TextStyle(color:  Color.fromRGBO(232, 206, 77, 1.0)),
                    controller: _nameEditingController,
                
                    decoration: InputDecoration(
                      
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(232, 206, 77, 1.0),
                              width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter category',
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(232, 206, 77, 1.0))),
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
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        final _name = _nameEditingController.text;
                        if (_name.isEmpty) {
                          return;
                        }

                        final _type = selectedCategoryNotifier.value;
                        final _category = CategoryModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: _name,
                            type: _type);

                        CategoryDB.instance.insertCategory(_category);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('ADD')),
                )
              ],
            ),
          ),
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
        ValueListenableBuilder(
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
