import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'estudante_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myrollcall.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE estudantes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            ra TEXT NOT NULL,
            bloco TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> inserirEstudante(Estudante aluno) async {
    final db = await instance.database;
    return await db.insert('estudantes', aluno.toMap());
  }

  Future<List<Estudante>> listarEstudantes() async {
    final db = await instance.database;
    final resultado = await db.query('estudantes', orderBy: 'nome ASC');
    return resultado.map((json) => Estudante.fromMap(json)).toList();
  }
}