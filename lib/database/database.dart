
import 'package:path_provider/path_provider.dart';
import 'package:phone_login/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _db;

  DatabaseHelper._instance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'data';
  String colPriority = 'priority';
  String colStatus = 'status';

  /*
  This is how out note table will look
  Id | Title | Date | Priority | Status
  0    " "     " "    "  "        0
  1    " "     " "    "  "        1

  * */

  Future<Database?> get db async{
    _db ??= await _initDb();
    return _db;
  }
  Future<Database> _initDb() async{

    var dir = await getApplicationDocumentsDirectory();
    var path = dir.path + 'todo_list.db';
    final todoListDB = await openDatabase(
        path, version: 1, onCreate: _createDb
    );
    return todoListDB;
  }

  void _createDb(Database db, int version) async{
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER )'
    );
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    var db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(noteTable);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    final noteMapList = await getNoteMapList();

    final noteList = <Note>[];

    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));

    });
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));
    return noteList;
  }

  Future<int> insertNote(Note note) async {
    var db = await this.db;
    final result = await db!.insert(
      noteTable,
      note.toMap(),

    );
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await this.db;
    final result = await db!.update(
      noteTable,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
    return result;
  }


  Future<int> deleteNote(int id) async {
    var db = await this.db;
    final result = await db!.delete(
      noteTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

}

