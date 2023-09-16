import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_lec/model/transactions.dart';

class TransactionFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser!;

  // Add a user-specific transaction
  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('transactions')
          .add(transaction.toJson());
    } catch (e) {
      // Handle the error as needed
    }
  }

  // Retrieve a specific user's transactions ordered by date
  Stream<List<Transactions>> getTransactionsByUser() {
    return _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transactions.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Transactions>> getIncomeTransactionsByUser() {
    return _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('transactions')
        .where('isExpense', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transactions.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Transactions>> getIsExpenseTransactionsByUser() {
    return _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('transactions')
        .where('isExpense', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transactions.fromJson(doc.data()))
            .toList());
  }
}
