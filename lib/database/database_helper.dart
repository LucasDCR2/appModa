// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';
import 'cor.dart';
import 'package:logger/logger.dart';


//================================================< DataBase >===================================================//

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
      tamanho TEXT,
      preco REAL,
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
      {
        'corPrincipal': 'Azul',
        'codigoCorPrincipal': '#0000FF',
        'corCombinante': 'Azul',
        'codigoCorCombinante': '#0000FF'
      },
      {
        'corPrincipal': 'Azul',
        'codigoCorPrincipal': '#0000FF',
        'corCombinante': 'Verde',
        'codigoCorCombinante': '#00FF00'
      },
      {
        'corPrincipal': 'Vermelho',
        'codigoCorPrincipal': '#FF0000',
        'corCombinante': 'Vermelho',
        'codigoCorCombinante': '#FF0000'
      },
      {
        'corPrincipal': 'Vermelho',
        'codigoCorPrincipal': '#FF0000',
        'corCombinante': 'Roxo',
        'codigoCorCombinante': '#800080'
      },
      // Adicione outras relações de cores combinantes conforme necessário
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
      tamanho: maps[i]['tamanho'],
      preco: maps[i]['preco'],
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
      tamanho: maps[i]['tamanho'],
      preco: maps[i]['preco'],
      qrCode: maps[i]['qrCode'],
    );

    return produto;
  });
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

}


//======================================================< Fim >=======================================================//