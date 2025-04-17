import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Habit {
  final int id;
  final String name;
  final String repeatOn;

  const Habit({required this.id, required this.name, required this.repeatOn});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'repeat': repeatOn};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Habit{id: $id, name: $name, repeatOn: $repeatOn}';
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
    final List<Map<String,dynamic>> query = await db.query('habit');

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

