import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableFilm = 'films';
final String colonneAlternativeTitles = 'alternativeTitles';
final String colonneSynopsis = 'synopsis';
final String colonneImage = 'image';

final String databaseName = 'FilmDB.db';
final int databaseVersion = 1;

class Film {
  String? alternativeTitles;
  String? synopsis;
  String? image;

  Film(this.alternativeTitles, this.synopsis, this.image);

  Film.fromMap(Map<dynamic, dynamic> map) {
    alternativeTitles = map[colonneAlternativeTitles];
    synopsis = map[colonneSynopsis];
    image = map[colonneImage];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colonneAlternativeTitles: alternativeTitles,
      colonneSynopsis: synopsis,
      colonneImage: image
    };
    return map;
  }
}

class FilmProvider {
  static final FilmProvider instance = FilmProvider._privateConstructor();

  Database? _db;

  FilmProvider._privateConstructor();

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
          CREATE TABLE $tableFilm (
            $colonneAlternativeTitles TEXT NOT NULL,
            $colonneSynopsis TEXT NOT NULL,
            $colonneImage TEXT NOT NULL,
            PRIMARY KEY ($colonneAlternativeTitles)
          )
          ''');
  }

  Future<int> insert(Film film) async {
    Database db = await instance.db;
    Film? filmExistant = await rechercheFilmParTitre(film.alternativeTitles!);
    if (filmExistant != null) {
      return -1;
    }
    return await db.insert(tableFilm, film.toMap());
  }

  Future<Film?> rechercheFilmParTitre(String alternativeTitles) async {
    Database db = await instance.db;
    List<Map> maps = await db.query(tableFilm,
        columns: [colonneAlternativeTitles, colonneSynopsis, colonneImage],
        where: '$colonneAlternativeTitles = ?',
        whereArgs: [alternativeTitles]);
    if (maps.length > 0) {
      return Film.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Film>> getAllFilms() async {
    Database db = await instance.db;
    List<Map> maps = await db.query(tableFilm);
    List<Film> films = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        films.add(Film.fromMap(maps[i]));
      }
    }
    return films;
  }

  Future<int> delete(String alternativeTitles) async {
    Database db = await instance.db;
    return await db.delete(tableFilm,
        where: '$colonneAlternativeTitles = ?', whereArgs: [alternativeTitles]);
  }

  Future<int> update(Film film) async {
    Database db = await instance.db;
    return await db.update(tableFilm, film.toMap(),
        where: '$colonneAlternativeTitles = ?',
        whereArgs: [film.alternativeTitles]);
  }

  Future<int> clear() async {
    Database db = await instance.db;
    return await db.delete(tableFilm);
  }

  Future close() async {
    Database db = await instance.db;
    db.close();
  }

  Future<bool> isTableExists() async {
    final Database? db = await instance.db;
    final result = await db?.query(tableFilm);
    if (result != null && result.isNotEmpty) {
      return true;
    }
    else{
      return false;
    }
  }
}
