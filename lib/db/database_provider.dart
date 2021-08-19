import 'package:movielisting/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_MOVIE = "movie";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_DESP = "desp";
  static const String COLUMN_FAV = "isFav";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'movieDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating movie table");

        await database.execute(
          "CREATE TABLE $TABLE_MOVIE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_DESP TEXT,"
          "$COLUMN_FAV INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;

    var movies = await db
        .query(TABLE_MOVIE, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_DESP, COLUMN_FAV]);

    List<Movie> movieList = <Movie>[];

    movies.forEach((currentMovie) {
      Movie movie = Movie.fromMap(currentMovie);

      movieList.add(movie);
    });

    return movieList;
  }

  Future<Movie> insert(Movie movie) async {
    final db = await database;
    movie.id = await db.insert(TABLE_MOVIE, movie.toMap());
    return movie;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_MOVIE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Movie movie) async {
    final db = await database;

    return await db.update(
      TABLE_MOVIE,
      movie.toMap(),
      where: "id = ?",
      whereArgs: [movie.id],
    );
  }
}