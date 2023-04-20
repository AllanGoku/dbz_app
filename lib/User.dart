import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableUser = 'user';
final String colonneMail = 'mail';
final String colonnePassword = 'password';

final String databaseName = 'UserDB.db';
final int databaseVersion = 1;

class User {
  String? mail;
  String? password;

  User(this.mail, this.password);

  User.fromMap(Map<dynamic, dynamic> map) {
    mail = map[colonneMail];
    password = map[colonnePassword];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colonneMail: mail,
      colonnePassword: password
    };
    return map;
  }
}

class UserProvider {
  static final UserProvider instance = UserProvider._privateConstructor();

  Database? _db;

  UserProvider._privateConstructor();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDatabase();
      return _db!;
    }
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUser (
            $colonneMail TEXT NOT NULL,
            $colonnePassword TEXT NOT NULL,
            PRIMARY KEY ($colonneMail)
          )
          ''');
  }

  Future<int> insert(User user) async {
    Database db = await instance.db;
    User? userExistant = await rechercheUserParMail(user.mail!);
    if (userExistant != null) {
      return -1;
    }
    return await db.insert(tableUser, user.toMap());
  }

  Future<User?> rechercheUserParMail(String mail) async {
    Database db = await instance.db;
    List<Map> maps = await db.query(tableUser,
        columns: [colonneMail, colonnePassword],
        where: '$colonneMail = ?',
        whereArgs: [mail]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await instance.db;
    List<Map> maps = await db.query(tableUser);
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<int> delete(String mail) async {
    Database db = await instance.db;
    return await db
        .delete(tableUser, where: '$colonneMail = ?', whereArgs: [mail]);
  }

  Future<int> update(User user) async {
    Database db = await instance.db;
    return await db.update(tableUser, user.toMap(),
        where: '$colonneMail = ?', whereArgs: [user.mail]);
  }

  Future<int> clear() async {
    Database db = await instance.db;
    return await db.delete(tableUser);
  }

  Future close() async {
    Database db = await instance.db;
    db.close();
  }
}