import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print('Upgrading database...');
      await db.execute('ALTER TABLE favorites ADD COLUMN genres TEXT');
      print('Database upgraded');
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      genres TEXT,
      rating REAL,
      backgroundImage TEXT,
      addedAt TEXT NOT NULL
    )
  ''');
  }

  Future<void> addFavorite(Map<String, dynamic> game) async {
    final db = await database;
    await db.insert(
      'favorites',
      game,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await database;
    return await db.query('favorites', orderBy: 'addedAt DESC');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
