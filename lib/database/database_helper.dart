import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE materials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        course TEXT NOT NULL,
        semester INTEGER NOT NULL,
        subject TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        course TEXT NOT NULL,
        semester INTEGER NOT NULL,
        subject TEXT NOT NULL,
        note_text TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        course TEXT NOT NULL,
        semester INTEGER NOT NULL,
        subject TEXT NOT NULL,
        status TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        course TEXT NOT NULL,
        semester INTEGER NOT NULL,
        subject TEXT NOT NULL,
        UNIQUE(username, course, semester, subject)
      )
    ''');

    await db.execute('''
      CREATE TABLE announcements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        course TEXT NOT NULL,
        semester INTEGER NOT NULL,
        subject TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }


  Future<int> insertUser(String username, String email, String password) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'username': username,
        'email': email,
        'password': password,
      });
    } catch (e) {
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String email, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ? AND email = ? AND password = ?',
        whereArgs: [username, email, password]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> usernameExists(String username) async {
    final db = await database;
    final result =
    await db.query('users', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty;
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final result =
    await db.query('users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }


  Future<int> addMaterial(String username, String course, int semester,
      String subject, String title, String type, String description) async {
    final db = await database;
    return await db.insert('materials', {
      'username': username,
      'course': course,
      'semester': semester,
      'subject': subject,
      'title': title,
      'type': type,
      'description': description,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMaterials(String username,
      String course, int semester, String subject) async {
    final db = await database;
    return await db.query('materials',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject],
        orderBy: 'created_at DESC');
  }

  Future<int> deleteMaterial(int id) async {
    final db = await database;
    return await db.delete('materials', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> addNote(String username, String course, int semester,
      String subject, String noteText) async {
    final db = await database;
    return await db.insert('notes', {
      'username': username,
      'course': course,
      'semester': semester,
      'subject': subject,
      'note_text': noteText,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getNotes(
      String username, String course, int semester, String subject) async {
    final db = await database;
    return await db.query('notes',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject],
        orderBy: 'created_at DESC');
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateNote(int id, String newText) async {
    final db = await database;
    return await db.update('notes', {'note_text': newText},
        where: 'id = ?', whereArgs: [id]);
  }


  Future<int> addAttendance(String username, String course, int semester,
      String subject, String status) async {
    final db = await database;
    return await db.insert('attendance', {
      'username': username,
      'course': course,
      'semester': semester,
      'subject': subject,
      'status': status,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAttendance(
      String username, String course, int semester, String subject) async {
    final db = await database;
    return await db.query('attendance',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject],
        orderBy: 'date DESC');
  }

  Future<int> deleteAttendance(int id) async {
    final db = await database;
    return await db
        .delete('attendance', where: 'id = ?', whereArgs: [id]);
  }


  Future<void> toggleFavorite(String username, String course, int semester,
      String subject) async {
    final db = await database;
    final exists = await db.query('favorites',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject]);
    if (exists.isNotEmpty) {
      await db.delete('favorites',
          where:
          'username = ? AND course = ? AND semester = ? AND subject = ?',
          whereArgs: [username, course, semester, subject]);
    } else {
      await db.insert('favorites', {
        'username': username,
        'course': course,
        'semester': semester,
        'subject': subject,
      });
    }
  }

  Future<bool> isFavorite(String username, String course, int semester,
      String subject) async {
    final db = await database;
    final result = await db.query('favorites',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject]);
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites(String username) async {
    final db = await database;
    return await db
        .query('favorites', where: 'username = ?', whereArgs: [username]);
  }


  Future<int> addAnnouncement(String username, String course, int semester,
      String subject, String title, String body) async {
    final db = await database;
    return await db.insert('announcements', {
      'username': username,
      'course': course,
      'semester': semester,
      'subject': subject,
      'title': title,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAnnouncements(
      String username, String course, int semester, String subject) async {
    final db = await database;
    return await db.query('announcements',
        where:
        'username = ? AND course = ? AND semester = ? AND subject = ?',
        whereArgs: [username, course, semester, subject],
        orderBy: 'created_at DESC');
  }

  Future<int> deleteAnnouncement(int id) async {
    final db = await database;
    return await db
        .delete('announcements', where: 'id = ?', whereArgs: [id]);
  }
}