import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Habit {
  final int id;
  final String name;
  final String repeatOn; //frequ

  const Habit({required this.id, required this.name, required this.repeatOn});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'repeatOn': repeatOn};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Habit{id: $id, name: $name, repeatOn: $repeatOn}';
  }
}


class Task {
  final int id;
  final int habitId;
  final String title;
  int completed;

  Task({required this.id, required this.habitId, required this.title, required this.completed});

  Map<String, Object?> toMap() {
    return {'id': id, 'habitId': habitId, 'title': title, 'completed': completed};
  }

  bool get isCompleted => completed == 1;
  set isCompleted(bool value) {
    completed = value ? 1 : 0;
  }
  // bool isCompleted() {
  //   if (completed == 1) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Task{id: $id, habitId: $habitId, title: $title, completed: $completed}';
  }
}


class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      //path
      join(await getDatabasesPath(), 'habit_db.db'),
      //table creation
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habit(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            repeatOn TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE task(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habitId INTEGER,
            title TEXT,
            completed INTEGER,
            FOREIGN KEY (habitId) REFERENCES habit(id) ON DELETE CASCADE
          )
        ''');
      },
      /*
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          '''
      CREATE TABLE habit(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      repeatOn TEXT)
      ''',
        );
      },
      */
      version: 1,
    );
  }


  //========== HABIT ===============

  // INSERT
  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habit',
      {
        //room.toMap(), //is easy but maps everything including id, which wont AI
        'name': habit.name,
        'repeatOn': habit.repeatOn,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // LIST
  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> query = await db.query('habit');

    List<Habit> habits = [];
    query.forEach((map) {
      habits.add(Habit(
        id: map['id'],
        name: map['name'],
        repeatOn: map['repeatOn'],
      ));
    });

    return habits;
  }

  // UPDATE
  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habit',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete(
      'habit',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  //========== TASK ===============

  // INSERT
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'task',
      {
        //room.toMap(), //is easy but maps everything including id, which wont AI
        'habitId': task.habitId,
        'title': task.title,
        'completed': task.completed,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // LIST
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> query = await db.query('task');

    List<Task> tasks = [];
    query.forEach((map) {
      tasks.add(Task(
        id: map['id'],
        habitId: map['habitId'],
        title: map['title'],
        completed: map['completed'],
      ));
    });

    return tasks;
  }

  // UPDATE
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  //========== GENERAL ===============

  //DELETE DB
  Future<void> deleteDB() async {
    final dbPath = join(await getDatabasesPath(), 'habit_db.db');
    await deleteDatabase(dbPath);
  }



// GUIDE
/*
// Insert a Room
final dbHelper = DBHelper();
await dbHelper.insertRoom(Room(
  id: 0, // SQLite will auto-generate it
  name: 'John Doe',
  contactPhone: '123-456-7890',
  ssn: '987-65-4321',
  address: '123 Main St',
));

// Retrieve All Rooms
List<Room> rooms = await dbHelper.getRooms();
for (var room in rooms) {
  print(room.toMap());
}

// Update a Room
Room updatedRoom = Room(
  id: 1, // ID of the room to update
  name: 'Jane Doe',
  contactPhone: '555-1234',
  ssn: '000-00-0000',
  address: '456 New St',
);
await dbHelper.updateRoom(updatedRoom);

// Delete a Room
await dbHelper.deleteRoom(1); // Deletes room with ID 1
 */
}
