import 'package:flutter/foundation.dart'; // Required for kDebugMode
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class LocalDbService {
  static final String _dbName = 'diversitree.db';
  static Database? _database;
  static bool _isNewTableCreated = false; // Flag to track table creation

  // Initialize or get the database
  static Future<Database> get _getDatabase async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create and initialize the database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    if (kDebugMode) {
      print('Initializing database at path: $path');
    }

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        if (kDebugMode) {
          print('Creating table: workspaces');
        }

        await db.execute('''
          CREATE TABLE workspaces (
            id TEXT PRIMARY KEY,
            urutan_status_workspace INTEGER NOT NULL,
            nama_workspace TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        _isNewTableCreated = true; // Set the flag if the table was created
      },
    );

    return db;
  }

  // Method to drop the database
  static Future<void> dropDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    try {
      // Check if the database file exists
      final dbFile = File(path);
      if (await dbFile.exists()) {
        // Delete the database file
        await dbFile.delete();
        if (kDebugMode) {
          print('Database dropped at path: $path');
        }
      } else {
        if (kDebugMode) {
          print('Database file does not exist at path: $path');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error dropping database: $e');
      }
    }
  }

  // This method will return if the table was created or not
  static bool get isNewTableCreated {
    return _isNewTableCreated;
  }

  // Insert multiple records into a table
  static Future<void> insertAll(String table, List<Map<String, dynamic>> data) async {
    final db = await _getDatabase;

    // Create a batch to execute multiple insert operations
    Batch batch = db.batch();

    for (var record in data) {
      batch.insert(table, record);
    }

    // Commit the batch to the database
    await batch.commit();
    if (kDebugMode) {
      print('Inserted ${data.length} records into $table');
    }
  }

  // Insert data into a table
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _getDatabase;
    if (kDebugMode) {
      print('Inserting into $table: $data');
    }
    return await db.insert(table, data);
  }

  static Future<int> insertMany(String table, List<Map<String, dynamic>> data) async {
    final db = await _getDatabase;

    // Create a batch to execute multiple insert operations
    Batch batch = db.batch();

    // Add insert operations for each record in the data list
    for (var record in data) {
      batch.insert(table, record);
    }

    // Commit the batch to the database and return the result
    List<dynamic> result = await batch.commit(noResult: false);

    // Count how many records were inserted by checking the result's length
    int insertedCount = result.length;

    if (kDebugMode) {
      print('Inserted $insertedCount records into $table');
    }

    return insertedCount; // Return the count of inserted records
  }

  // Retrieve all rows from a table
  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await _getDatabase;
    final data = await db.query(table); // First get the data from the DB
    if (kDebugMode) {
      print('Data retrieved from $table: $data'); // Then print the data
    }
    return data; // Return the fetched data
  }

  // Update data in a table
  static Future<int> update(
      String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    final db = await _getDatabase;
    final rowsUpdated = await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
    if (kDebugMode) {
      print('Updated $rowsUpdated rows in $table with $data where $where args: $whereArgs');
    }
    return rowsUpdated;
  }

  // Delete data from a table
  static Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await _getDatabase;
    final rowsDeleted = await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
    if (kDebugMode) {
      print('Deleted $rowsDeleted rows from $table where $where args: $whereArgs');
    }
    return rowsDeleted;
  }

  // Execute custom SQL query
  static Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? args]) async {
    final db = await _getDatabase;
    final data = await db.rawQuery(sql, args); // First get the data
    if (kDebugMode) {
      print('Raw query executed: $sql args: $args, result: $data'); // Then print the result
    }
    return data; // Return the fetched data
  }

  // Execute custom SQL command
  static Future<void> execute(String sql) async {
    final db = await _getDatabase;
    if (kDebugMode) {
      print('Executing SQL command: $sql');
    }
    await db.execute(sql);
  }
}
