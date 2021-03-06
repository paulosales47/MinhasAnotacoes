import 'package:minhas_anotacoes/models/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{
  static final AnotacaoHelper _anotacaoHelper =  AnotacaoHelper._internal();
  Database _database;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();

  get database async{
    if(_database != null)
      return _database;

    _database = await _inicializarDatabase();
    return _database;
  }

  Future<Database> _inicializarDatabase() async{
    final caminhoBancoDados = await getDatabasesPath();
    final localBanco = join(caminhoBancoDados, "DB_MINHAS_ANOTACOES.db");

    var database = await openDatabase(
      localBanco,
      version: 1,
      onCreate: (database, version) async{
        await database.execute(""
            "CREATE TABLE TB_ANOTACAO "
            "("
              "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
              "TITULO VARCHAR,"
              "DESCRICAO TEXT,"
              "DATA_CADASTRO DATETIME,"
              "DATA_ATUALIZACAO DATETIME"
            ")");
      }
    );

    return database;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{
      Database db = await database;
      int idAnotacaoInserida = await db.insert("TB_ANOTACAO", anotacao.toMap());
      return idAnotacaoInserida;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async{
    anotacao.dataAtualizacao = DateTime.now().toString();

    Database db = await database;
    int qtdRegistrosAtualizados = await db.update(
      "TB_ANOTACAO",
      anotacao.toMap(),
      where: "ID = ?",
      whereArgs: [anotacao.id]
    );
    return qtdRegistrosAtualizados;
  }

  Future<int> removerAnotacao(Anotacao anotacao) async{
    anotacao.dataAtualizacao = DateTime.now().toString();

    Database db = await database;
    int qtdRegistrosRemovidos = await db.delete(
        "TB_ANOTACAO",
        where: "ID = ?",
        whereArgs: [anotacao.id]
    );
    return qtdRegistrosRemovidos;
  }

  Future<List<Map<String, dynamic>>> listarAnotacoes() async{
    Database bd = await database;
    String sql = "SELECT ID, TITULO, DESCRICAO, DATA_CADASTRO, DATA_ATUALIZACAO FROM TB_ANOTACAO ORDER BY DATA_CADASTRO DESC";
    List anotacoes = await bd.rawQuery(sql);
    return anotacoes;
  }




}