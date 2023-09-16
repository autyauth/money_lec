import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_lec/model/transactions.dart';
import 'package:money_lec/page/all_transaction_page.dart';
import 'package:money_lec/page/income_page.dart';
import 'package:money_lec/page/isExpense_page.dart';
import 'package:money_lec/screens/login_screen.dart';
import 'package:money_lec/screens/new_transaction_screen.dart';
import 'package:money_lec/services/transaction_firestore_service.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late List<Transactions> _transactions = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User user = FirebaseAuth.instance.currentUser!;
  double _totalMoney = 0;
  //final List<Widget> _page = [AllTransactionPage(transactions: transactions),IncomePage(transactions: transactions),IsExpensePage(transactions: transactions)];
  int _currentIndex = 0;
  List<Widget> _page = [];
  @override
  void initState() {
    super.initState();

    _refreshTransaction();
  }

  @override
  void dispose() {
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
        _page = [
          AllTransactionPage(transactions: transactions),
          IncomePage(transactions: _getIncomeTransactions()),
          IsExpensePage(transactions: _getExpenseTransactions())
        ];
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

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
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
              child: IndexedStack(
                index: _currentIndex,
                children: _page,
              ),
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/accounting.png')),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/feather (1).png')),
              label: 'รายรับ'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/bankruptcy.png')),
              label: 'รายจ่าย'),
        ],
      ),
    );
  }

  List<Transactions> _getIncomeTransactions() {
    return _transactions
        .where((transaction) => !transaction.isExpense)
        .toList();
  }

  List<Transactions> _getExpenseTransactions() {
    return _transactions.where((transaction) => transaction.isExpense).toList();
  }
}
