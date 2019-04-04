import 'dart:io';
import 'package:phonedailer/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._(); 
  Database _database;
  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Contacts.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          '''CREATE TABLE Contacts (_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    fname TEXT NOT NULL,
                    lname TEXT NOT NULL,
                    numberPhone TEXT NOT NULL,
                    
                    email TEXT,
                    
                    pic TEXT) ''');
    });
  }

  Future<int> newContact(Contact contact) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(_id)+1 as _id FROM Contacts ");
    int id = table.first["_id"];
    var raw = await db.rawInsert(
        '''INSERT Into Contacts (_id,fname,lname,numberPhone,email,pic) VALUES (?,?,?,?,?,?)''',
        [
          id,
          contact.fname,
          contact.lname,
          contact.numberPhone,
          contact.email,
          contact.pic
        ]);
    return raw;
  }

  Future<List<Contact>> getAllContact() async {
    final db = await database;
    var res = await db.query(('Contacts'),orderBy: "fname");
    List<Contact> list =
        res.isNotEmpty ? res.map((c) => Contact.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Contact>> getSearchResulte(String query) async {
    final db = await database;
    var res = await db.rawQuery(
        '''SELECT * FROM Contacts WHERE fname LIKE '%$query%' OR lname LIKE '%$query%' OR numberPhone LIKE '%$query%' ''');
    List<Contact> list =
        res.isNotEmpty ? res.map((c) => Contact.fromMap(c)).toList() : [];
    return list;
  }

  updateContact(Contact contact) async {
    final db = await database;
    var res = await db.update("Contacts", contact.toMap(),
        where: "_id = ?", whereArgs: [contact.id]);

    return res;
  }

  deleteDB() async {
    final db = await database;
    db.delete("Contacts");
  }

  delete(Contact contact) async {
    final db = await database;
    db.rawDelete("Delete FROM Contacts WHERE _id=?", [contact.id]);
  }
}
