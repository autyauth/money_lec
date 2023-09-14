const String tableTransactions = 'transactions';

class TransactionFields {
  // static class for storing the values of the table or accessing them without creating an instance of the class
  static final List<String> values = [
    id,
    title,
    isExpense,
    amount,
    date,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String isExpense = 'isExpense';
  static const String amount = 'amount';
  static const String date = 'date';
}

class Transactions {
  int? id;
  String title;
  bool isExpense = false;
  double amount;
  DateTime date;

  Transactions(
      {this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.isExpense});

  static Transactions fromJson(Map<String, Object?> json) => Transactions(
      // fromJson is a method from transaction.dart for converting the json to transaction
      id: json[TransactionFields.id] as int?,
      title: json[TransactionFields.title] as String,
      isExpense: json[TransactionFields.isExpense] == 1,
      amount: json[TransactionFields.amount] as double,
      date: DateTime.parse(json[TransactionFields.date] as String));

  Map<String, Object?> toJson() => {
        // toJson is a method from transaction.dart for converting the transaction to json
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.isExpense: isExpense ? 1 : 0,
        TransactionFields.amount: amount,
        TransactionFields.date: date.toIso8601String(),
      };
  // use TransactionFields because it is a static class and we can access its values without creating an instance of it
  Transactions copy({
    int? id,
    String? title,
    bool? isExpense,
    double? amount,
    DateTime? date,
  }) =>
      Transactions(
        id: id ?? this.id,
        title: title ?? this.title,
        isExpense: isExpense ?? this.isExpense,
        amount: amount ?? this.amount,
        date: date ?? this.date,
      );
}
