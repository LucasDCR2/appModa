// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'produto.dart';

class DatabaseProvider {
  static const _databaseName = 'seu_banco.db';
  static const _databaseVersion = 1;

  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagem BLOB,
        nome TEXT,
        cor TEXT,
        tamanho TEXT,
        preco REAL
      )
    ''');
  }

  Future<List<Produto>> getProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        imagem: maps[i]['imagem'],
        nome: maps[i]['nome'],
        cor: maps[i]['cor'],
        tamanho: maps[i]['tamanho'],
        preco: maps[i]['preco'],
      );
    });
  }

  Future<void> insertProduto(Produto produto) async {
    final db = await database;
    await db.insert('produtos', produto.toMap());
  }

  Future<void> deleteAllProdutos() async {
  final db = await database;
  await db.delete('produtos');
}

  Future<void> initializeDatabase() async {
    _database = await _initDatabase();
  }
}
