import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/widgets/transactions/transaction_widget.dart';

class IncomePage extends StatelessWidget {
  final List<Transactions> incomeTransactions; // รายการรายรับ

  IncomePage({required this.incomeTransactions});
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: incomeTransactions.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (index == 0 ||
                !isSameDay(incomeTransactions[index - 1].date,
                    incomeTransactions[index].date))
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 5.0,
                ),
                child: Text(
                  DateFormat.yMd().format(incomeTransactions[index].date),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TransactionWidget(
              transaction: incomeTransactions[index],
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }
  incomeTransactions[index].title,
              incomeTransactions[index].amount,
              incomeTransactions[index].date,
              incomeTransactions[index].isExpense,
}
