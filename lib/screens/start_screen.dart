import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lec/db/transactions_database.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/screens/login_screen.dart';
import 'package:money_lec/screens/new_transaction_screen.dart';
import 'package:money_lec/services/transaction_firestore_service.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late List<Transactions> _transactions = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User user = FirebaseAuth.instance.currentUser!;
  double _totalMoney = 0;
  DateTime? _selectedDate; // เพิ่มตัวแปรสำหรับเก็บวันที่ที่ถูกเลือก

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
    final transactionsStream =
        TransactionFirestoreService().getTransactionsByUser();

    transactionsStream.listen((List<Transactions> transactions) {
      final totalMoney = _getTotalMoney(transactions);
      setState(() {
        _transactions = transactions;
        _totalMoney = totalMoney;
      });
    });
  }

  double _getTotalMoney(List<Transactions> transactions) {
    double totalMoney = 0;
    for (int i = 0; i < transactions.length; i++) {
      if (transactions[i].isExpense) {
        totalMoney -= transactions[i].amount;
      } else {
        totalMoney += transactions[i].amount;
      }
    }
    return totalMoney;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).primaryColor;
    _refreshTransaction();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<DateTime>(
                    value: _selectedDate,
                    items: [
                      DropdownMenuItem<DateTime>(
                        value: null,
                        child: Text('ทั้งหมด'),
                      ),
                      ..._transactions
                          .map((transaction) => transaction.date)
                          .toSet()
                          .toList()
                          .map(
                            (date) => DropdownMenuItem<DateTime>(
                              value: date,
                              child: Text(DateFormat.yMd().format(date)),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    },
                    hint: Text('เลือกวันที่'),
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
                    final transaction = _transactions[index];
                    if (_selectedDate == null ||
                        transaction.date == _selectedDate) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 4.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: elementTransaction(
                              transaction.title,
                              transaction.amount,
                              transaction.date,
                              transaction.isExpense,
                            ),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
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
                  userEmail: user.email!,
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
                Text(DateFormat.yMd().format(date)),
                Text(isExpense0),
                Text(title),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              amount.toString(),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
