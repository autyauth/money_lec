import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lec/db/transactions_database.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/screens/new_transaction_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late List<Transactions> _transactions = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _totalMoney = 0;

  @override
  void initState() {
    super.initState();
    _refreshTransaction();
  }

  @override
  void dispose() {
    TransactionsDatabase.instance.close();

    super.dispose();
  }

  Future<void> _refreshTransaction() async {
    final transactions =
        await TransactionsDatabase.instance.readAllTransactions();
    final totalMoney = _getTotalMoney();
    setState(() {
      _transactions = transactions;
      _totalMoney = totalMoney;
    });
  }

  double _getTotalMoney() {
    double totalMoney = 0;
    for (int i = 0; i < _transactions.length; i++) {
      if (_transactions[i].isExpense) {
        totalMoney -= _transactions[i].amount;
      } else {
        totalMoney += _transactions[i].amount;
      }
    }
    return totalMoney;
  }

  @override
  Widget build(BuildContext context) {
    _refreshTransaction();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0XFFFF69B4),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: const Color(0XFFFF69B4),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'กระเป๋าเงิน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Row(children: [
                  Text(
                    '(THB)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'ยอดสุทธิ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
                Text(
                  _totalMoney.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    if (_transactions.isNotEmpty) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 4.0,
                          ),
                          elementTransaction(
                              _transactions[index].title,
                              _transactions[index].amount,
                              _transactions[index].date,
                              _transactions[index].isExpense),
                          const SizedBox(
                            height: 3.0,
                          ),
                        ],
                      );
                    }
                    return null;
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _scaffoldKey.currentState?.showBottomSheet(
            (BuildContext context) {
              return Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0XFFFF69B4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: NewTransactionsScreen(
                  onRefresh: _refreshTransaction,
                ),
              );
            },
          );
          await _refreshTransaction();
        },
        backgroundColor: const Color(0XFFFFFFFF),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Image(
            image: AssetImage('assets/images/pencil.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'test'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'test'),
        ],
      ),
    );
  }

  Widget elementTransaction(
      String title, double amount, DateTime date, bool isExpense) {
    String isExpense0;
    if (isExpense) {
      isExpense0 = 'รายจ่าย';
    } else {
      isExpense0 = 'รายรับ';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(44, 255, 105, 180),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.money, size: 30),
        ),
        Expanded(
          child: Column(
            children: [
              Text(DateFormat.yMd().format(date)),
              Text(isExpense0),
              Text(title),
            ],
          ),
        ),
        Text(amount.toString()),
      ],
    );
  }
}
