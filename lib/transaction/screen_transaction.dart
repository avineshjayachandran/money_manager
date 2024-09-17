import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category_db/category_db.dart';
import 'package:money_manager/db/transaction_db/transaction_db.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:money_manager/model/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.Refresh();
    CategoryDB.instance.refreshUI();

    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.TransactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _value = newlist[index];

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Slidable(
                    key: Key(_value.id!),
                    startActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          TransactionDB.instance.deleteTransaction(_value.id!);
                        },
                        icon: Icons.delete,
                        foregroundColor:
                            const Color.fromRGBO(60,59,61,1),
                            backgroundColor:const Color.fromRGBO(179, 179, 179, 1),
                       
                      )
                    ]),
                    child: Card(
                      child: Container(
                        height: 80,
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          tileColor: const Color.fromRGBO(60, 59, 61, 1),
                          textColor: const Color.fromRGBO(232, 206, 77, 1.0),
                          title: Text(
                            _value.purpose,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _value.amount.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            parseDate(_value.date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          selectedTileColor: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, item) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newlist.length);
        });
        
  }

  String parseDate(DateTime date) {
    return DateFormat.MMMMd().format(date);
    // return "${date.day - date.month}";
  }
}
