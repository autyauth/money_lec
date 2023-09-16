import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/widgets/transactions/transaction_widget.dart';

class AllTransactionPage extends StatelessWidget {
  final List<Transactions> transactions; // รายการรายรับ

  AllTransactionPage({required this.transactions});
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (index == 0 ||
                !isSameDay(
                    transactions[index - 1].date, transactions[index].date))
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 5.0,
                ),
                child: Text(
                  DateFormat.yMd().format(transactions[index].date),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TransactionWidget(
              transaction: transactions[index],
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }
}
