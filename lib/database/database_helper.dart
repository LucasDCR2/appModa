// ignore_for_file: unnecessary_null_comparison

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';
import 'cor.dart';
import 'package:logger/logger.dart';

class DatabaseProvider {
  static const _databaseName = 'seu_banco.db';
  static const _databaseVersion = 1;

  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();

  late Database _database;
  final Logger logger = Logger();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    // Abra o banco de dados
    final db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Execute a criação das tabelas
        await _createDatabase(db, version);

        // Registre uma mensagem de sucesso após a criação do banco de dados
        logger.d('Banco de dados criado com sucesso');
      },
    );

    return db;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imagem BLOB,
      nome TEXT,
      cor TEXT,
      corNome TEXT,
      tamanho TEXT,
      preco REAL
    )
  ''');

    await db.execute('''
    CREATE TABLE cores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      cor TEXT
    )
  ''');

    // Insira algumas cores iniciais
    final cores = [
      {'nome': 'Vermelho', 'cor': '#FF0000'},
      {'nome': 'Azul', 'cor': '#0000FF'},
      {'nome': 'Verde', 'cor': '#00FF00'},
      {'nome': 'Amarelo', 'cor': '#FFFF00'},
      {'nome': 'Roxo', 'cor': '#800080'},
      {'nome': 'Laranja', 'cor': '#FFA500'},
      {'nome': 'Preto', 'cor': '#000000'},
      {'nome': 'Branco', 'cor': '#FFFFFF'},
      {'nome': 'Cinza', 'cor': '#808080'},
    ];

    for (final corData in cores) {
      final result = await db.insert('cores', corData);
      if (result != null) {
        logger.d('Cor inserida com sucesso: ${corData['nome']}');
      } else {
        logger.e('Falha ao inserir cor: ${corData['nome']}');
      }
    }
  }

  Future<List<Cor>> getCores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cores');
    return List.generate(maps.length, (i) {
      return Cor(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        cor: maps[i]['cor'], // Ler o valor hex da cor
      );
    });
  }

  Future<List<Produto>> getProdutos() async {
    final db = await database;

    // Execute a consulta SQL que inclui a nova coluna 'corNome'
    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        imagem: maps[i]['imagem'],
        nome: maps[i]['nome'],
        cor: maps[i]['cor'],
        corNome: maps[i]['corNome'],
        tamanho: maps[i]['tamanho'],
        preco: maps[i]['preco'],
      );
    });
  }

  Future<void> insertProduto(Produto produto) async {
    final db = await database;
    await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> getProdutosPorCor(String cor, String corNome) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'cor = ? AND corNome = ?',
      whereArgs: [cor, corNome],
    );

    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        imagem: maps[i]['imagem'],
        nome: maps[i]['nome'],
        cor: maps[i]['cor'],
        corNome: maps[i]['corNome'],
        tamanho: maps[i]['tamanho'],
        preco: maps[i]['preco'],
      );
    });
  }

  Future<void> deleteAllProdutos() async {
    final db = await database;
    await db.delete('produtos');
  }

  Future<void> initializeDatabase() async {
    _database = await _initDatabase();
  }
}
