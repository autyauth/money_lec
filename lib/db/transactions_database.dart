import 'package:money_lec/model/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsDatabase {
  static final TransactionsDatabase instance = TransactionsDatabase
      ._init(); // _init is a private constructor for the class
  // static means that we can access the instance of the class without creating an instance of the class

  static Database? _database;
  TransactionsDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB('notes.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const boolType = 'BOOLEAN NOT NULL';
    // const doubleType = 'DOUBLE NOT NULL';
    // const textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE $tableTransactions (
  ${TransactionFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TransactionFields.title} TEXT NOT NULL,
  ${TransactionFields.amount} DOUBLE NOT NULL,
  ${TransactionFields.date} TEXT NOT NULL,
  ${TransactionFields.isExpense} INTEGER NOT NULL
)
''');
  }

  Future<Transactions> create(Transactions transaction) async {
    final db = await instance.database;
    final id = await db!.insert(tableTransactions, transaction.toJson());
    return transaction.copy(
        id: id); // copy is a method from transaction.dart for copying the transaction and editing it
  }

  Future<Transactions> readTransaction(int id) async {
    final db = await instance.database;
    final maps = await db!.query(
      tableTransactions,
      columns: TransactionFields.values,
      where: '${TransactionFields.id} = ?',
      whereArgs: [
        id
      ], // ? is replaced with whereArgs for security reasons from SQL injection
    );
    if (maps.isNotEmpty) {
      return Transactions.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Transactions>> readAllTransactions() async {
    final db = await instance.database;
    const orderBy =
        '${TransactionFields.date} ASC'; // ASC is for ascending order
    final result = await db!.query(tableTransactions, orderBy: orderBy);
    return result.map((json) => Transactions.fromJson(json)).toList();
  }

  Future<int> update(Transactions transaction) async {
    final db = await instance.database;
    return db!.update(tableTransactions,
        transaction.toJson(), where: '${TransactionFields.id} = ?', whereArgs: [
      transaction.id
    ]); // ? is replaced with whereArgs for security reasons from SQL injection
    //update by id
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db!.delete(tableTransactions,
        where: '${TransactionFields.id} = ?',
        whereArgs: [
          id
        ]); // ? is replaced with whereArgs for security reasons from SQL injection
    //delete by id
  }

  Future<void> close() async {
    final db = await instance.database;
    db!.close();
  }
}
