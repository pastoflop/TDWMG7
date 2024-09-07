import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/producto.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_producto TEXT,
        valor REAL,
        disponibilidad INTEGER
      )
    ''');
  }

  Future<int> insertProducto(Producto producto) async {
    Database db = await database;
    return await db.insert('productos', producto.toMap());
  }

  Future<List<Producto>> getProductos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productos');
    return List.generate(maps.length, (i) {
      return Producto.fromMap(maps[i]);
    });
  }

  Future<int> updateProducto(Producto producto) async {
    Database db = await database;
    return await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<int> deleteProducto(int id) async {
    Database db = await database;
    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
