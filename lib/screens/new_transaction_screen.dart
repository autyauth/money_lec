import 'package:flutter/material.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/services/transaction_firestore_service.dart';
import 'package:money_lec/widgets/new_transaction/button_confirm.dart';
import 'package:money_lec/widgets/new_transaction/button_date.dart';
import 'package:money_lec/widgets/new_transaction/button_isExpense.dart';

class NewTransactionsScreen extends StatefulWidget {
  const NewTransactionsScreen(
      {super.key, required this.onRefresh, required this.userEmail});
  final Function() onRefresh;
  final String userEmail;
  @override
  State<NewTransactionsScreen> createState() => _NewTransactionsScreenState();
}

class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  bool _isExpense = false;

  @override
  void initState() {
    super.initState();
    _title.text = '';
    _amount.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40.0,
        ),
        Container(
          height: 40,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(children: [
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'ตัวโน๊ต',
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: _amount,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  label: Text('(THB)'),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonDate(onPressed: (date) {
              setState(() {
                _selectedDate = date;
              });
            }),
            const SizedBox(
              width: 10.0,
            ),
            ButtonIsExpense(
              onPressed: (isExpense) {
                setState(() {
                  _isExpense = isExpense;
                });
              },
            ),
            const SizedBox(
              width: 10.0,
            ),
            ButtonConfirm(canConfirm: (ok) async {
              await addTransaction(widget.userEmail);
              widget.onRefresh();
            })
          ],
        )
      ],
    );
  }

  Future<void> addTransaction(String email) async {
    try {
      final Transactions newTransaction = Transactions(
        title: _title.text,
        amount: double.parse(_amount.text),
        date: _selectedDate,
        isExpense: _isExpense,
      );
      await TransactionFirestoreService().addTransaction(newTransaction);
    } catch (e) {
      // Handle any exceptions that may occur during database operations.
      // ignore: avoid_print
      print('Error adding transaction: $e');
    }
  }
}
