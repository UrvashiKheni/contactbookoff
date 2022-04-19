import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper
{

  Future<Database> createdatabase()
  async
  {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE contactbook (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, email TEXT , password TEXT)');
        });

    print(database);

    return database;

  }


}