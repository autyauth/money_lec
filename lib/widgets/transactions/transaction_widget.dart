import 'package:flutter/material.dart';
import 'package:money_lec/model/transactions.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({super.key, required this.transaction});
  final Transactions transaction;

  @override
  Widget build(BuildContext context) {
    return elementTransaction(transaction.title, transaction.amount,
        transaction.date, transaction.isExpense);
  }
}

Widget elementTransaction(
    String title, double amount, DateTime date, bool isExpense) {
  String isExpense0;
  if (isExpense) {
    isExpense0 = 'รายจ่าย';
  } else {
    isExpense0 = 'รายรับ';
  }
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(44, 255, 105, 180),
      borderRadius: BorderRadius.circular(100),
    ),
    height: 60,
    width: 270,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(44, 255, 105, 180),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.money, size: 30),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(isExpense0),
              Text(title),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              amount.toString(),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    ),
  );
}
