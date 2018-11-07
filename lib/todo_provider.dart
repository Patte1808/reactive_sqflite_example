import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:streamqflite/streamqflite.dart';
import 'package:path/path.dart';


final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Todo {
  int id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database _db;
  StreamDatabase _streamDatabase;
  bool _didInit = false;

  Future _open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "todo.db");
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
        });

    _streamDatabase = StreamDatabase(_db);

    _didInit = true;
  }

  Future _init() async {
    if (!_didInit) {
      await _open();
    }
  }

  Future<Todo> insert(Todo todo) async {
    await _init();
    todo.id = await _streamDatabase.insert(tableTodo, todo.toMap());
    return todo;
  }

  Stream<List<Todo>> getAll() async* {
    await _init();

    yield* _streamDatabase.createQuery(tableTodo,
        columns: [columnId, columnDone, columnTitle],).mapToList((map) => Todo.fromMap(map));
  }

  Future close() async => _db.close();
}