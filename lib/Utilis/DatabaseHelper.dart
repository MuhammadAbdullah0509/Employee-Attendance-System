/*
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) {
      return _db!;
    } else {
      await initDatabase();
    }
  }

  initDatabase() async {
    final path = join(await getDatabasesPath(), 'Ecomerence.db');
    _db = await openDatabase(path, version: 1, onCreate: onCreate);
    return _db;
  }

  onCreate(db, version) async {
    await db.execute('''
      CREATE TABLE productCart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            Image TEXT,
            price TEXT,
            Category TEXT,
            quantity TEXT,
            Description TEXT
)
    ''');
  }

  Future<int?> insertProduct(ProductModel product) async {
    final db = await database;
    int? row = await db!.insert('productCart', product.toMap());
    return row;
  }

  Future<List<ProductModel>> getAllProduct() async {
    final db = await database;
    final List<Map<String, Object?>> list = await db!.query('productCart');
    return list.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    int row = await db!.delete('productCart', where: 'id=$id');
    return row;
  }
}


*/
