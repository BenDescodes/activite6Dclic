import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modele/note.dart';
import '../modele/utilisateur.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();

  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialiserDatabase();
    return _database!;
  }

  Future<Database> _initialiserDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'mynote_app.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _creerDatabase,
    );
  }

  Future<void> _creerDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomUtilisateur TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        motDePasse TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        utilisateurId INTEGER NOT NULL,
        contenu TEXT NOT NULL,
        realise INTEGER NOT NULL DEFAULT 0,
        dateCreation TEXT NOT NULL,
        dateModification TEXT NOT NULL,
        FOREIGN KEY (utilisateurId) REFERENCES utilisateurs (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> registerUtilisateur(Utilisateur utilisateur) async {
    final db = await database;

    return await db.insert(
      'utilisateurs',
      utilisateur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Utilisateur?> loginUtilisateur({
    required String identifiant,
    required String motDePasse,
  }) async {
    final db = await database;

    final result = await db.query(
      'utilisateurs',
      where: '(nomUtilisateur = ? OR email = ?) AND motDePasse = ?',
      whereArgs: [identifiant, identifiant, motDePasse],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Utilisateur.fromMap(result.first);
  }

  Future<List<Note>> getAllNotes(int utilisateurId) async {
    final db = await database;

    final result = await db.query(
      'notes',
      where: 'utilisateurId = ?',
      whereArgs: [utilisateurId],
      orderBy: 'id DESC',
    );

    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await database;

    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;

    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;

    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
