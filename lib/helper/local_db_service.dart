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
      print('LocalDbWorkspace: Initializing database at path: $path');
    }

    final db = await openDatabase(
      path,
      readOnly: false,
      version: 1,
      onCreate: (db, version) async {
        if (kDebugMode) {
          print('LocalDbWorkspace: Creating table: workspaces');
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

  // Drop the 'workspaces' table if it exists
  static Future<void> dropTable() async {
    final db = await _getDatabase;

    try {
      if (kDebugMode) {
        print('LocalDbWorkspace: Dropping all rows from table: workspaces');
      }

      // Attempt to delete all rows from the table
      await db.execute('DELETE FROM workspaces');

      if (kDebugMode) {
        print('LocalDbWorkspace: All rows deleted from table: workspaces');
      }
    } catch (e) {
      // Catch any exception and print/log it
      if (kDebugMode) {
        print('Error deleting rows from workspaces: $e');
      }
    }

    // Optionally reset the flag if needed
    _isNewTableCreated = false;
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
          print('LocalDbWorkspace: Database dropped at path: $path');
        }
      } else {
        if (kDebugMode) {
          print('LocalDbWorkspace: Database file does not exist at path: $path');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('LocalDbWorkspace: Error dropping database: $e');
      }
    }

    await dropTable();
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
      print('LocalDbWorkspace: Inserted ${data.length} records into $table');
    }
  }

  // Insert data into a table
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await _getDatabase;
    if (kDebugMode) {
      print('LocalDbWorkspace: Inserting into $table: $data');
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
      print('LocalDbWorkspace: Inserted $insertedCount records into $table');
    }

    return insertedCount; // Return the count of inserted records
  }

  // Insert or Update Method with Debug Prints (only in debug mode)
  static Future<void> insertOrUpdate(String table, Map<String, dynamic> item) async {
    final db = await _getDatabase;

    // Print the incoming item for debugging purposes only in debug mode
    if (kDebugMode) {
      print("Received item for insertOrUpdate: $item");
    }

    String? existingItemId = item['id'];

    if (existingItemId != null) {
      // If the id is not null, try updating the existing record
      if (kDebugMode) {
        print("Item has an existing id: $existingItemId");
      }

      int count = await db.update(
        table,
        item,
        where: 'id = ?',
        whereArgs: [existingItemId],
      );

      if (count == 0) {
        // If no rows were updated (i.e., no record found), insert it as new
        if (kDebugMode) {
          print("No record found with id $existingItemId. Inserting new record.");
        }
        await db.insert(
          table,
          item,
          conflictAlgorithm: ConflictAlgorithm.replace, // This will replace the old record
        );
        if (kDebugMode) {
          print("New record inserted: $item");
        }
      } else {
        if (kDebugMode) {
          print("Existing record updated with id: $existingItemId");
        }
      }
    } else {
      // If no id exists (new record), insert it directly
      if (kDebugMode) {
        print("No existing id, inserting new record.");
      }
      await db.insert(
        table,
        item,
        conflictAlgorithm: ConflictAlgorithm.replace, // This will replace the old record if there is a conflict
      );
      if (kDebugMode) {
        print("New record inserted: $item");
      }
    }
  }

  // Retrieve all rows from a table
  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await _getDatabase;
    final data = await db.query(table); // First get the data from the DB
    if (kDebugMode) {
      print('LocalDbWorkspace: Data retrieved from $table: $data'); // Then print the data
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
      print('LocalDbWorkspace: Updated $rowsUpdated rows in $table with $data where $where args: $whereArgs');
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
      print('LocalDbWorkspace: Deleted $rowsDeleted rows from $table where $where args: $whereArgs');
    }
    return rowsDeleted;
  }

  // Execute custom SQL query
  static Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? args]) async {
    final db = await _getDatabase;
    final data = await db.rawQuery(sql, args); // First get the data
    if (kDebugMode) {
      print('LocalDbWorkspace: Raw query executed: $sql args: $args, result: $data'); // Then print the result
    }
    return data; // Return the fetched data
  }

  // Execute custom SQL command
  static Future<void> execute(String sql) async {
    final db = await _getDatabase;
    if (kDebugMode) {
      print('LocalDbWorkspace: Executing SQL command: $sql');
    }
    await db.execute(sql);
  }
}
