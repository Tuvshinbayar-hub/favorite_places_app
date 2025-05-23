import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? database;
  static final String tableName = 'places';

  Future<Database> getDatabase() async {
    if (database != null) return database!;

    String path = join(await getDatabasesPath(), 'favorite_places.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute('''CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          imagePath TEXT NOT NULL,
          address TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          mapImagePath TEXT NOT NULL)'''),
    );

    return database!;
  }

  Future<List<Map<String, dynamic>>> getAllPlaces() async {
    final db = await getDatabase();

    return await db.query(DatabaseHelper.tableName);
  }

  Future<void> insertPlace(Map<String, dynamic> place) async {
    final db = await getDatabase();

    await db.insert(DatabaseHelper.tableName, place,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deletePlace(int id) async {
    final db = await getDatabase();

    await db.delete(DatabaseHelper.tableName, where: 'id = $id');
  }
}
