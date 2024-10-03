import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "auth.db";

  String user = '''
CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT,
password TEXT,
email TEXT,
phone TEXT,
dob TEXT,
gender TEXT,
imagepath TEXT
)
''';
  Future<Database> InitDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(user);
      },
    );
  }
}
