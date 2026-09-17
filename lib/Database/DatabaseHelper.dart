
import 'package:maney_management_new/Modles/Categories.dart';
import 'package:maney_management_new/Modles/Wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Modles/Transactions.dart';

class DataBaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'masrofat.db');
    Database myDB = await openDatabase(path, onCreate: _onCreate, version: 2);
    return myDB;
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
     CREATE TABLE wallets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        balance REAL NOT NULL,
        currency TEXT NOT NULL
      )
    ''');
    batch.execute('''
    CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');
    batch.execute('''
      CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL NOT NULL,
          note TEXT,
          date TEXT NOT NULL,
          type TEXT NOT NULL, 
          categoryName TEXT ,
          categoryIcon TEXT ,
          categoryId INTEGER NOT NULL,
          walletId INTEGER NOT NULL,
          FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE,
          FOREIGN KEY (walletId) REFERENCES wallets (id) ON DELETE CASCADE
        )
    ''');
    await batch.commit();
    print("OnCreate ====================================");
  }

  //Wallet =====================================================

  Future<int> insertWallet(Wallet newWallet) async {
    Database? myDB = await db;
    int response = await myDB!.insert('wallets', newWallet.toMap());
    return response;
  }

  Future<List<Wallet>> getAllWallet() async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.query('wallets');
    return response.map((json) => Wallet.fromMap(json)).toList();
  }

  Future<int> deleteWallet(int id) async {
    Database? myDB = await db;
    int response = await myDB!.delete(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  Future<int> updateWallet(Wallet updateWallet) async {
    Database? myDB = await db;
    int response = await myDB!.update(
      'wallets',
      updateWallet.toMap(),
      where: 'id = ?',
      whereArgs: [updateWallet.id],
    );
    return response;
  }

  //Category ===================================================

  Future<int> insertCategory(Categories newCategory) async {
    Database? myDB = await db;
    int response = await myDB!.insert('categories', newCategory.toMap());
    return response;
  }

  Future<List<Categories>> getAllCategory() async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.query('categories');
    return response.map((json) => Categories.fromMap(json)).toList();
  }

  Future<int> updateCategory(Categories updateCategory) async {
    Database? myDB = await db;
    int response = await myDB!.update(
      'categories',
      updateCategory.toMap(),
      where: 'id = ?',
      whereArgs: [updateCategory.id],
    );
    return response;
  }

  Future<int> deleteCategory(int id) async {
    Database? myDB = await db;
    int response = await myDB!.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  //Transactions ===================================================

  Future<int> insertTransaction(Transactions newTransaction) async {
    Database? myDB = await db;
    int response = await myDB!.insert('transactions', newTransaction.toMap());
    return response;
  }

  Future<List<Transactions>> getAllTransaction() async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.query('transactions');
    return response.map((json) => Transactions.fromMap(json)).toList();
  }

  Future<int> updateTransaction(Transactions updateTrans) async {
    Database? myDB = await db;
    int response = await myDB!.update(
      'transactions',
      updateTrans.toMap(),
      where: 'id = ?',
      whereArgs: [updateTrans.id],
    );
    return response;
  }

  Future<int> deleteTransaction(int id) async {
    Database? myDB = await db;
    int response = await myDB!.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  Future<int> deleteAllTransaction() async {
    Database? myDB = await db;
    int response = await myDB!.delete('transactions');
    return response;
  }

  Future<double> getTotalAmountByType(String type) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? ',
      [type],
    );
    return response.first['total'] != null
        ? response.first['total'] as double
        : 0.0;
  }

  Future<List<Transactions>> getTransactionByWallet(int walletID) async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.query(
      'transactions',
      where: 'walletId = ?',
      whereArgs: [walletID],
    );
    return response.map((json) => Transactions.fromMap(json)).toList();
  }

  Future<double> getTotalExpenses() async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.rawQuery('''
    SELECT SUM(amount) as total
    FROM transactions
    WHERE type = 'expense'
  ''');
    if (response.isNotEmpty && response.first['total'] != null) {
      return double.parse(response.first['total'].toString());
    }
    return 0.0;
  }

  Future<double> getTotalIncome() async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.rawQuery('''
    SELECT SUM(amount) as total
    FROM transactions
    WHERE type = 'income'
   ''');
    if (response.isNotEmpty && response.first['total'] != null) {
      return double.parse(response.first['total'].toString());
    }
    return 0.0;
  }
}
