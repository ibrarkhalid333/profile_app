import 'package:path/path.dart';
import 'package:profile_app/core/JSON/users.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperClass {
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
// database creation
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

  // authentication

  Future<bool> authenticate(Users usr) async {
    final Database db = await InitDB();
    var result = await db.rawQuery(
        "select * from users where username = '${usr.username}' AND password = '${usr.password}'");
    if (result.isNotEmpty) {
      print('Login Successfuly');
      return true;
    } else {
      return false;
    }
  }

  //signup
  Future<int> createUser(Users usr) async {
    final Database db = await InitDB();
    return db.insert("users", usr.toMap());
  }

  // get user detail

  Future<Users?> getUser(String username) async {
    final db = await InitDB();
    var res =
        await db.query("users", where: "username =?", whereArgs: [username]);

    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<int> updateUser(String? username, Map<String, dynamic> updates) async {
    final Database db = await InitDB();
    int result = await db
        .update('users', updates, where: "username=?", whereArgs: [username]);
    return result;
  }
}
