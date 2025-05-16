import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/tasks.dart';
import 'package:todo/utils/db_keys.dart';


class TaskDatasource {
  static final TaskDatasource _instace = TaskDatasource._();
  factory TaskDatasource() => _instace;

  TaskDatasource._(){
    _initDB();
  }
  static Database? _database;

  Future<Database> get database async{
    _database ??=await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBKeys.dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate (Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DBKeys.dbTable}(
        ${DBKeys.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBKeys.titleColumn} TEXT,
        ${DBKeys.noteColumn} TEXT,
        ${DBKeys.dateColumn} TEXT,
        ${DBKeys.timeColumn} TEXT,
        ${DBKeys.categoryColumn} TEXT,
        ${DBKeys.isCompletedColumn} INTEGER
      )
      ''');
  }

  Future<int> addTask(Task task) async{
    final db = await database;
    return db.transaction((txn) async{
      return await txn.insert(
        DBKeys.dbTable,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // final DateTime taskDateTime = DateTime.parse('${task.date} ${task.time}:00');
      //
      // if (taskDateTime.isAfter(DateTime.now())) {
      //   await NotificationService.scheduleTaskNotification(
      //     id: id,
      //     title: 'Task Reminder: ${task.title}',
      //     body: 'Due on ${taskDateTime.toLocal().toString().split(" ")[0]}',
      //     Date: taskDateTime,
      //   );
      // }
      // return id;
    },
    );
  }

  Future<int> updateTask(Task task) async{
    final db = await database;
    return db.transaction((txn) async{
      return await txn.update(
        DBKeys.dbTable,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    },
    );
  }

  Future<int> deleteTask(Task task) async{
    final db = await database;
    // await NotificationService.cancelNotification(task.id!);
    return db.transaction((txn) async{
      return await txn.delete(
        DBKeys.dbTable,
        where: 'id = ?',
        whereArgs: [task.id],
      );
    },
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(
        DBKeys.dbTable,
      orderBy: "id DESC"
    );
    return List.generate(
      data.length,
          (index) => Task.fromJson(data[index]),
    );
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    final db = await database;
    final formattedDate = DateFormat.yMMMd().format(date); // Format the date to match your DB format

    final List<Map<String, dynamic>> result = await db.query(
      DBKeys.dbTable,
      where: '${DBKeys.dateColumn} = ?', // Query tasks where date matches
      whereArgs: [formattedDate], // Pass the formatted date
    );

    // Convert the query result to a list of Task objects
    return result.map((json) => Task.fromJson(json)).toList();
  }

}