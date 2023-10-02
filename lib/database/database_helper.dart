// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';
import 'cor.dart';
import 'package:logger/logger.dart';


//================================================< DataBase >===================================================//

class DatabaseProvider {
  static const _databaseName = 'tonalize.db';
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


//================================================< Inicialziar >===================================================//


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

  Future<void> initializeDatabase() async {
    _database = await _initDatabase();
  }


//================================================< Tabela Produtos >===================================================//


  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imagem BLOB,
      nome TEXT,
      cor TEXT,
      corNome TEXT,
      qrCode TEXT
    )
  ''');


//================================================< Tabela Cores >===================================================//


await db.execute('''
  CREATE TABLE cores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    cor TEXT
  )
''');

// Insira algumas cores iniciais
final cores = [
  {'nome': 'Rosa 1', 'cor': '#45060e'},
  {'nome': 'Rosa 2', 'cor': '#ba073f'},
  {'nome': 'Rosa 3', 'cor': '#e78ba4'},
  {'nome': 'Vermelho 1', 'cor': '#6c0506'},
  {'nome': 'Vermelho 2', 'cor': '#f50415'},
  {'nome': 'Vermelho 3', 'cor': '#fe6673'},
  {'nome': 'Laranja Escuro 1', 'cor': '#ab2e10'},
  {'nome': 'Laranja Escuro 2', 'cor': '#fd4919'},
  {'nome': 'Laranja Escuro 3', 'cor': '#ff8264'},
  {'nome': 'Laranja Médio 1', 'cor': '#c76404'},
  {'nome': 'Laranja Médio 2', 'cor': '#ff8e02'},
  {'nome': 'Laranja Médio 3', 'cor': '#fec786'},
  {'nome': 'Laranja Claro 1', 'cor': '#9a6900'},
  {'nome': 'Laranja Claro 2', 'cor': '#ffb400'},
  {'nome': 'Laranja Claro 3', 'cor': '#ffd778'},
  {'nome': 'Amarelo 1', 'cor': '#a29200'},
  {'nome': 'Amarelo 2', 'cor': '#feef00'},
  {'nome': 'Amarelo 3', 'cor': '#fff394'},
  {'nome': 'Verde Claro 1', 'cor': '#778a06'},
  {'nome': 'Verde Claro 2', 'cor': '#b2ce00'},
  {'nome': 'Verde Claro 3', 'cor': '#d7e46d'},
  {'nome': 'Verde Escuro 1', 'cor': '#015d07'},
  {'nome': 'Verde Escuro 2', 'cor': '#00a900'},
  {'nome': 'Verde Escuro 3', 'cor': '#99d492'},
  {'nome': 'Azul Claro 1', 'cor': '#003f37'},
  {'nome': 'Azul Claro 2', 'cor': '#05978b'},
  {'nome': 'Azul Claro 3', 'cor': '#a9e4de'},
  {'nome': 'Azul Médio 1', 'cor': '#0b1141'},
  {'nome': 'Azul Médio 2', 'cor': '#0497d1'},
  {'nome': 'Azul Médio 3', 'cor': '#d4ecf6'},
  {'nome': 'Azul Escuro 1', 'cor': '#1c2a4f'},
  {'nome': 'Azul Escuro 2', 'cor': '#3c5190'},
  {'nome': 'Azul Escuro 3', 'cor': '#bbc1d7'},
  {'nome': 'Roxo 1', 'cor': '#1b0035'},
  {'nome': 'Roxo 2', 'cor': '#3f2378'},
  {'nome': 'Roxo 3', 'cor': '#947aba'},
];

for (final corData in cores) {
  await db.insert('cores', corData);
}



//===========================================< Tabela Cores Combinantes >=============================================//


await db.execute('''
  CREATE TABLE cores_combinantes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    corPrincipal TEXT,
    codigoCorPrincipal TEXT, 
    corCombinante TEXT,
    codigoCorCombinante TEXT  
  )
''');

    final coresCombinantes = [
      {'corPrincipal': 'Rosa 1', 'codigoCorPrincipal': '#45060e', 'corCombinante': 'Verde Claro 1', 'codigoCorCombinante': '#778a06'},
      {'corPrincipal': 'Rosa 2', 'codigoCorPrincipal': '#ba073f', 'corCombinante': 'Verde Claro 2', 'codigoCorCombinante': '#b2ce00'},
      {'corPrincipal': 'Rosa 3', 'codigoCorPrincipal': '#e78ba4', 'corCombinante': 'Verde Claro 3', 'codigoCorCombinante': '#d7e46d'},
      {'corPrincipal': 'Vermelho 1', 'codigoCorPrincipal': '#6c0506', 'corCombinante': 'Verde Escuro 1', 'codigoCorCombinante': '#015d07'},
      {'corPrincipal': 'Vermelho 2', 'codigoCorPrincipal': '#f50415', 'corCombinante': 'Verde Escuro 2', 'codigoCorCombinante': '#00a900'},
      {'corPrincipal': 'Vermelho 3', 'codigoCorPrincipal': '#fe6673', 'corCombinante': 'Verde Escuro 3', 'codigoCorCombinante': '#99d492'},
      {'corPrincipal': 'Laranja Escuro 1', 'codigoCorPrincipal': '#ab2e10', 'corCombinante': 'Azul Claro 1', 'codigoCorCombinante': '#003f37'},
      {'corPrincipal': 'Laranja Escuro 2', 'codigoCorPrincipal': '#fd4919', 'corCombinante': 'Azul Claro 2', 'codigoCorCombinante': '#05978b'},
      {'corPrincipal': 'Laranja Escuro 3', 'codigoCorPrincipal': '#ff8264', 'corCombinante': 'Azul Claro 3', 'codigoCorCombinante': '#a9e4de'},
      {'corPrincipal': 'Laranja Médio 1', 'codigoCorPrincipal': '#c76404', 'corCombinante': 'Azul Médio 1', 'codigoCorCombinante': '#0b1141'},
      {'corPrincipal': 'Laranja Médio 2', 'codigoCorPrincipal': '#ff8e02', 'corCombinante': 'Azul Médio 2', 'codigoCorCombinante': '#0497d1'},
      {'corPrincipal': 'Laranja Médio 3', 'codigoCorPrincipal': '#fec786', 'corCombinante': 'Azul Médio 3', 'codigoCorCombinante': '#d4ecf6'},
      {'corPrincipal': 'Laranja Claro 1', 'codigoCorPrincipal': '#9a6900', 'corCombinante': 'Azul Escuro 1', 'codigoCorCombinante': '#1c2a4f'},
      {'corPrincipal': 'Laranja Claro 2', 'codigoCorPrincipal': '#ffb400', 'corCombinante': 'Azul Escuro 2', 'codigoCorCombinante': '#3c5190'},
      {'corPrincipal': 'Laranja Claro 3', 'codigoCorPrincipal': '#ffd778', 'corCombinante': 'Azul Escuro 3', 'codigoCorCombinante': '#bbc1d7'},
      {'corPrincipal': 'Amarelo 1', 'codigoCorPrincipal': '#a29200', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Amarelo 2', 'codigoCorPrincipal': '#feef00', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Amarelo 3', 'codigoCorPrincipal': '#fff394', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
      {'corPrincipal': 'Rosa 1', 'codigoCorPrincipal': '#45060e', 'corCombinante': 'Vermelho 1', 'codigoCorCombinante': '#6c0506'},
      {'corPrincipal': 'Rosa 2', 'codigoCorPrincipal': '#ba073f', 'corCombinante': 'Vermelho 2', 'codigoCorCombinante': '#f50415'},
      {'corPrincipal': 'Rosa 3', 'codigoCorPrincipal': '#e78ba4', 'corCombinante': 'Vermelho 3', 'codigoCorCombinante': '#fe6673'},
      {'corPrincipal': 'Vermelho 1', 'codigoCorPrincipal': '#6c0506', 'corCombinante': 'Laranja Escuro 1', 'codigoCorCombinante': '#ab2e10'},
      {'corPrincipal': 'Vermelho 2', 'codigoCorPrincipal': '#f50415', 'corCombinante': 'Laranja Escuro 2', 'codigoCorCombinante': '#fd4919'},
      {'corPrincipal': 'Vermelho 3', 'codigoCorPrincipal': '#fe6673', 'corCombinante': 'Laranja Escuro 3', 'codigoCorCombinante': '#ff8264'},
      {'corPrincipal': 'Laranja Escuro 1', 'codigoCorPrincipal': '#ab2e10', 'corCombinante': 'Laranja Médio 1', 'codigoCorCombinante': '#c76404'},
      {'corPrincipal': 'Laranja Escuro 2', 'codigoCorPrincipal': '#fd4919', 'corCombinante': 'Laranja Médio 2', 'codigoCorCombinante': '#ff8e02'},
      {'corPrincipal': 'Laranja Escuro 3', 'codigoCorPrincipal': '#ff8264', 'corCombinante': 'Laranja Médio 3', 'codigoCorCombinante': '#fec786'},
      {'corPrincipal': 'Laranja Médio 1', 'codigoCorPrincipal': '#c76404', 'corCombinante': 'Laranja Claro 1', 'codigoCorCombinante': '#9a6900'},
      {'corPrincipal': 'Laranja Médio 2', 'codigoCorPrincipal': '#ff8e02', 'corCombinante': 'Laranja Claro 2', 'codigoCorCombinante': '#ffb400'},
      {'corPrincipal': 'Laranja Médio 3', 'codigoCorPrincipal': '#fec786', 'corCombinante': 'Laranja Claro 3', 'codigoCorCombinante': '#ffd778'},
      {'corPrincipal': 'Laranja Claro 1', 'codigoCorPrincipal': '#9a6900', 'corCombinante': 'Amarelo 1', 'codigoCorCombinante': '#a29200'},
      {'corPrincipal': 'Laranja Claro 2', 'codigoCorPrincipal': '#ffb400', 'corCombinante': 'Amarelo 2', 'codigoCorCombinante': '#feef00'},
      {'corPrincipal': 'Laranja Claro 3', 'codigoCorPrincipal': '#ffd778', 'corCombinante': 'Amarelo 3', 'codigoCorCombinante': '#fff394'},
      {'corPrincipal': 'Amarelo 1', 'codigoCorPrincipal': '#a29200', 'corCombinante': 'Verde Claro 1', 'codigoCorCombinante': '#778a06'},
      {'corPrincipal': 'Amarelo 2', 'codigoCorPrincipal': '#feef00', 'corCombinante': 'Verde Claro 2', 'codigoCorCombinante': '#b2ce00'},
      {'corPrincipal': 'Amarelo 3', 'codigoCorPrincipal': '#fff394', 'corCombinante': 'Verde Claro 3', 'codigoCorCombinante': '#d7e46d'},
      {'corPrincipal': 'Verde Claro 1', 'codigoCorPrincipal': '#778a06', 'corCombinante': 'Verde Escuro 1', 'codigoCorCombinante': '#015d07'},
      {'corPrincipal': 'Verde Claro 2', 'codigoCorPrincipal': '#b2ce00', 'corCombinante': 'Verde Escuro 2', 'codigoCorCombinante': '#00a900'},
      {'corPrincipal': 'Verde Claro 3', 'codigoCorPrincipal': '#d7e46d', 'corCombinante': 'Verde Escuro 3', 'codigoCorCombinante': '#99d492'},
      {'corPrincipal': 'Verde Escuro 1', 'codigoCorPrincipal': '#015d07', 'corCombinante': 'Azul Claro 1', 'codigoCorCombinante': '#003f37'},
      {'corPrincipal': 'Verde Escuro 2', 'codigoCorPrincipal': '#00a900', 'corCombinante': 'Azul Claro 2', 'codigoCorCombinante': '#05978b'},
      {'corPrincipal': 'Verde Escuro 3', 'codigoCorPrincipal': '#99d492', 'corCombinante': 'Azul Claro 3', 'codigoCorCombinante': '#a9e4de'},
      {'corPrincipal': 'Azul Claro 1', 'codigoCorPrincipal': '#003f37', 'corCombinante': 'Azul Médio 1', 'codigoCorCombinante': '#0b1141'},
      {'corPrincipal': 'Azul Claro 2', 'codigoCorPrincipal': '#05978b', 'corCombinante': 'Azul Médio 2', 'codigoCorCombinante': '#0497d1'},
      {'corPrincipal': 'Azul Claro 3', 'codigoCorPrincipal': '#a9e4de', 'corCombinante': 'Azul Médio 3', 'codigoCorCombinante': '#d4ecf6'},
      {'corPrincipal': 'Azul Médio 1', 'codigoCorPrincipal': '#0b1141', 'corCombinante': 'Azul Escuro 1', 'codigoCorCombinante': '#1c2a4f'},
      {'corPrincipal': 'Azul Médio 2', 'codigoCorPrincipal': '#0497d1', 'corCombinante': 'Azul Escuro 2', 'codigoCorCombinante': '#3c5190'},
      {'corPrincipal': 'Azul Médio 3', 'codigoCorPrincipal': '#d4ecf6', 'corCombinante': 'Azul Escuro 3', 'codigoCorCombinante': '#bbc1d7'},
      {'corPrincipal': 'Azul Escuro 1', 'codigoCorPrincipal': '#1c2a4f', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Azul Escuro 2', 'codigoCorPrincipal': '#3c5190', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Azul Escuro 3', 'codigoCorPrincipal': '#bbc1d7', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
      {'corPrincipal': 'Roxo 1', 'codigoCorPrincipal': '#1b0035', 'corCombinante': 'Rosa 1', 'codigoCorCombinante': '#45060e'},
      {'corPrincipal': 'Roxo 2', 'codigoCorPrincipal': '#3f2378', 'corCombinante': 'Rosa 2', 'codigoCorCombinante': '#ba073f'},
      {'corPrincipal': 'Roxo 3', 'codigoCorPrincipal': '#947aba', 'corCombinante': 'Rosa 3', 'codigoCorCombinante': '#e78ba4'},
      {'corPrincipal': 'Rosa 1', 'codigoCorPrincipal': '#45060e', 'corCombinante': 'Laranja Claro 1', 'codigoCorCombinante': '#9a6900'},
      {'corPrincipal': 'Rosa 2', 'codigoCorPrincipal': '#ba073f', 'corCombinante': 'Laranja Claro 2', 'codigoCorCombinante': '#ffb400'},
      {'corPrincipal': 'Rosa 3', 'codigoCorPrincipal': '#e78ba4', 'corCombinante': 'Laranja Claro 3', 'codigoCorCombinante': '#ffd778'},
      {'corPrincipal': 'Vermelho 1', 'codigoCorPrincipal': '#6c0506', 'corCombinante': 'Amarelo 1', 'codigoCorCombinante': '#a29200'},
      {'corPrincipal': 'Vermelho 2', 'codigoCorPrincipal': '#f50415', 'corCombinante': 'Amarelo 2', 'codigoCorCombinante': '#feef00'},
      {'corPrincipal': 'Vermelho 3', 'codigoCorPrincipal': '#fe6673', 'corCombinante': 'Amarelo 3', 'codigoCorCombinante': '#fff394'},
      {'corPrincipal': 'Laranja Escuro 1', 'codigoCorPrincipal': '#ab2e10', 'corCombinante': 'Verde Claro 1', 'codigoCorCombinante': '#778a06'},
      {'corPrincipal': 'Laranja Escuro 2', 'codigoCorPrincipal': '#fd4919', 'corCombinante': 'Verde Claro 2', 'codigoCorCombinante': '#b2ce00'},
      {'corPrincipal': 'Laranja Escuro 3', 'codigoCorPrincipal': '#ff8264', 'corCombinante': 'Verde Claro 3', 'codigoCorCombinante': '#d7e46d'},
      {'corPrincipal': 'Laranja Médio 1', 'codigoCorPrincipal': '#c76404', 'corCombinante': 'Verde Escuro 1', 'codigoCorCombinante': '#015d07'},
      {'corPrincipal': 'Laranja Médio 2', 'codigoCorPrincipal': '#ff8e02', 'corCombinante': 'Verde Escuro 2', 'codigoCorCombinante': '#00a900'},
      {'corPrincipal': 'Laranja Médio 3', 'codigoCorPrincipal': '#fec786', 'corCombinante': 'Verde Escuro 3', 'codigoCorCombinante': '#99d492'},
      {'corPrincipal': 'Laranja Claro 1', 'codigoCorPrincipal': '#9a6900', 'corCombinante': 'Azul Claro 1', 'codigoCorCombinante': '#003f37'},
      {'corPrincipal': 'Laranja Claro 2', 'codigoCorPrincipal': '#ffb400', 'corCombinante': 'Azul Claro 2', 'codigoCorCombinante': '#05978b'},
      {'corPrincipal': 'Laranja Claro 3', 'codigoCorPrincipal': '#ffd778', 'corCombinante': 'Azul Claro 3', 'codigoCorCombinante': '#a9e4de'},
      {'corPrincipal': 'Amarelo 1', 'codigoCorPrincipal': '#a29200', 'corCombinante': 'Azul Médio 1', 'codigoCorCombinante': '#0b1141'},
      {'corPrincipal': 'Amarelo 2', 'codigoCorPrincipal': '#feef00', 'corCombinante': 'Azul Médio 2', 'codigoCorCombinante': '#0497d1'},
      {'corPrincipal': 'Amarelo 3', 'codigoCorPrincipal': '#fff394', 'corCombinante': 'Azul Médio 3', 'codigoCorCombinante': '#d4ecf6'},
      {'corPrincipal': 'Verde Claro 1', 'codigoCorPrincipal': '#778a06', 'corCombinante': 'Azul Escuro 1', 'codigoCorCombinante': '#1c2a4f'},
      {'corPrincipal': 'Verde Claro 2', 'codigoCorPrincipal': '#b2ce00', 'corCombinante': 'Azul Escuro 2', 'codigoCorCombinante': '#3c5190'},
      {'corPrincipal': 'Verde Claro 3', 'codigoCorPrincipal': '#d7e46d', 'corCombinante': 'Azul Escuro 3', 'codigoCorCombinante': '#bbc1d7'},
      {'corPrincipal': 'Verde Escuro 1', 'codigoCorPrincipal': '#015d07', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Verde Escuro 2', 'codigoCorPrincipal': '#00a900', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Verde Escuro 3', 'codigoCorPrincipal': '#99d492', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
      {'corPrincipal': 'Azul Claro 1', 'codigoCorPrincipal': '#003f37', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Azul Claro 2', 'codigoCorPrincipal': '#05978b', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Azul Claro 3', 'codigoCorPrincipal': '#a9e4de', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
      {'corPrincipal': 'Azul Médio 1', 'codigoCorPrincipal': '#0b1141', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Azul Médio 2', 'codigoCorPrincipal': '#0497d1', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Azul Médio 3', 'codigoCorPrincipal': '#d4ecf6', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
      {'corPrincipal': 'Azul Escuro 1', 'codigoCorPrincipal': '#1c2a4f', 'corCombinante': 'Roxo 1', 'codigoCorCombinante': '#1b0035'},
      {'corPrincipal': 'Azul Escuro 2', 'codigoCorPrincipal': '#3c5190', 'corCombinante': 'Roxo 2', 'codigoCorCombinante': '#3f2378'},
      {'corPrincipal': 'Azul Escuro 3', 'codigoCorPrincipal': '#bbc1d7', 'corCombinante': 'Roxo 3', 'codigoCorCombinante': '#947aba'},
    ];

for (final relacao in coresCombinantes) {
      await db.insert('cores_combinantes', relacao);
    }
  }


//==============================================< GetCores e Combinantes >===============================================//


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

  Future<List<String>> getCoresCombinantes(String nomeCor, String codigoCorPrincipal) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT corCombinante, codigoCorCombinante FROM cores_combinantes WHERE corPrincipal = ? OR codigoCorPrincipal = ?',
      [nomeCor, codigoCorPrincipal],
    );

    return List.generate(maps.length, (i) {
      return maps[i]['codigoCorCombinante'];
    });
  }

Future<List<String>> getCoresPrincipais(String nomeCor, String codigoCorCombinante) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.rawQuery(
    'SELECT corPrincipal, codigoCorPrincipal FROM cores_combinantes WHERE corCombinante = ? OR codigoCorCombinante = ?',
    [nomeCor, codigoCorCombinante],
  );

  return List.generate(maps.length, (i) {
    return maps[i]['codigoCorPrincipal'];
  });
}



  Future<List<Map<String, dynamic>>> carregarCombinacoesDoBanco() async {
    final db = await database;
    final List<Map<String, dynamic>> combinacoes = await db.query('cores_combinantes');
    return combinacoes;
}


//==============================================< GetProdutos P Cor >===============================================//

    
Future<List<Produto>> getProdutosPorCores(List<String> coresCombinantes) async {
  debugPrint('Cores para buscar: ($coresCombinantes)');
  final db = await database;

  final placeholders = List.filled(coresCombinantes.length, '?').join(', ');

  final List<Map<String, dynamic>> maps = await db.rawQuery(
    'SELECT * FROM produtos WHERE cor IN ($placeholders)', coresCombinantes,
  );

  return List.generate(maps.length, (i) {
    return Produto(
      id: maps[i]['id'],
      imagem: maps[i]['imagem'],
      nome: maps[i]['nome'],
      cor: maps[i]['cor'],
      corNome: maps[i]['corNome'],
      qrCode: maps[i]['qrCode'],
    );
  });
}


//================================================< GetProdutos >===================================================//


 Future<List<Produto>> getProdutos() async {
  final db = await database;

  // Execute a consulta SQL que inclui a nova coluna 'corNome'
  final List<Map<String, dynamic>> maps = await db.query('produtos');

  return List.generate(maps.length, (i) {
    final produto = Produto(
      id: maps[i]['id'],
      imagem: maps[i]['imagem'],
      nome: maps[i]['nome'],
      cor: maps[i]['cor'],
      corNome: maps[i]['corNome'],
      qrCode: maps[i]['qrCode'],
    );

      return produto;
    });
  }

  Future<Produto?> getProdutoPorId(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Produto(
        id: maps[0]['id'],
        imagem: maps[0]['imagem'],
        nome: maps[0]['nome'],
        cor: maps[0]['cor'],
        corNome: maps[0]['corNome'],
        qrCode: maps[0]['qrCode'],
      );
    } else {
      return null; // Produto não encontrado
    }
  }
  

//==========================================< Insert e Delete Produto >=============================================//


  Future<void> insertProduto(Produto produto) async {
    final db = await database;
    await db.insert('produtos', produto.toMap());
  }

  Future<void> deleteAllProdutos() async {
    final db = await database;
    await db.delete('produtos');
  }

  Future<void> excluirProduto(Produto produto) async {
  final db = await database;
  await db.delete('produtos', where: 'id = ?', whereArgs: [produto.id]);
}



//================================================< Delete Cores >===================================================//


  Future<void> deleteAllCores() async {
    final db = await database;
    await db.delete('cores');
  }

  Future<void> deleteCor(int corId) async {
    final db = await database;
    await db.delete('cores', where: 'id = ?', whereArgs: [corId]);
  }


//==============================================< Delete Combinacoes >===============================================//


Future<void> deleteAllCoresCombinantes() async {
    final db = await database;
    await db.delete('cores_combinantes');
  }

  Future<void> deleteCorCombinante(int combinacaoId) async {
    final db = await database;
    await db.delete('cores_combinantes', where: 'id = ?', whereArgs: [combinacaoId]);
  }


//==============================================< Editar Produto >===============================================//


Future<void> atualizarProduto(Produto produto, BuildContext context) async {
  final db = await DatabaseProvider.instance.database;
  await db.update('produtos', produto.toMap(), where: 'id = ?', whereArgs: [produto.id]);

  // Exiba um snackbar de confirmação.
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Produto atualizado com sucesso!'),
      duration: Duration(seconds: 2), 
    ),
  );
}

Future<bool> verificaProdutoExiste(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty; // Retorna true se houver resultados (o ID existe), caso contrário, retorna false.
  }
}


//======================================================< Fim >=======================================================//