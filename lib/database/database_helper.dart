import 'dart:convert';

import 'package:movie_show_watchlist/classes/media.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('watchlist.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE media (
        id INTEGER NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        posterPath TEXT,
        genres TEXT NOT NULL,
        directors TEXT NOT NULL,
        status TEXT NOT NULL,
        rating REAL,
        PRIMARY KEY (id, type)
      )
    ''');
  }

  Future<void> insertMedia(Media media) async {
    final db = await instance.database;

    await db.insert(
      'media',
      _mediaToMap(media),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Media>> getAllMedia() async {
    final db = await instance.database;

    final rows = await db.query(
      'media',
      orderBy: 'title COLLATE NOCASE ASC',
    );

    return rows.map(_mapToMedia).toList();
  }

  Future<void> updateMedia(Media media) async {
    final db = await instance.database;

    await db.update(
      'media',
      _mediaToMap(media),
      where: 'id = ? AND type = ?',
      whereArgs: [media.id, _mediaTypeToString(media.type)],
    );
  }

  Future<void> updateStatus({
    required int id,
    required MediaType type,
    required Status status,
  }) async {
    final db = await instance.database;

    await db.update(
      'media',
      {'status': status.name},
      where: 'id = ? AND type = ?',
      whereArgs: [id, _mediaTypeToString(type)],
    );
  }

  Future<void> deleteMedia(Media media) async {
    final db = await instance.database;

    await db.delete(
      'media',
      where: 'id = ? AND type = ?',
      whereArgs: [media.id, _mediaTypeToString(media.type)],
    );
  }

  Map<String, dynamic> _mediaToMap(Media media) {
    return {
      'id': media.id,
      'type': _mediaTypeToString(media.type),
      'title': media.title,
      'posterPath': media.posterPath,
      'genres': jsonEncode(media.genres?.map((genre) => genre.name).toList() ?? []),
      'directors': jsonEncode(media.directors ?? []),
      'status': media.status.name,
      'rating': media.rating,
    };
  }

  Media _mapToMedia(Map<String, dynamic> map) {
    final genreNames = _decodeStringList(map['genres'] as String?);
    final directors = _decodeStringList(map['directors'] as String?);

    return Media(
      id: map['id'] as int,
      title: map['title'] as String,
      genres: genreNames.map(_stringToGenre).toList(),
      directors: directors,
      posterPath: map['posterPath'] as String?,
      status: _stringToStatus(map['status'] as String?),
      type: _stringToMediaType(map['type'] as String?),
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }

  List<String> _decodeStringList(String? value) {
    if (value == null || value.isEmpty) return [];

    final decoded = jsonDecode(value);
    if (decoded is! List) return [];

    return decoded.map((item) => item.toString()).toList();
  }

  String _mediaTypeToString(MediaType type) {
    switch (type) {
      case MediaType.movies:
        return 'movie';
      case MediaType.tvShows:
        return 'tv';
    }
  }

  MediaType _stringToMediaType(String? type) {
    switch (type) {
      case 'tv':
        return MediaType.tvShows;
      case 'movie':
      default:
        return MediaType.movies;
    }
  }

  Status _stringToStatus(String? value) {
    return Status.values.firstWhere(
      (status) => status.name == value,
      orElse: () => Status.notWatched,
    );
  }

  Genre _stringToGenre(String value) {
    return Genre.values.firstWhere(
      (genre) => genre.name == value,
      orElse: () => Genre.unknown,
    );
  }
}
