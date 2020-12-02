import 'Note.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static Database _db;

  static bool get isInit {
    return _db != null;
  }

  static Future<void> initDB() async {
    if (isInit) {
      return;
    }
    String dir = await getDatabasesPath();
    String path = dir + '/Database.db';
    _db = await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE IF NOT EXISTS Deals (
          id INT AUTO_INCREMENT PRIMARY KEY,
          deal VARCHAR(200),
          start DATETIME,
          end DATETIME,
          done BIT
          )""");
    });
  }

  static void addNote(Note note) {
    // _db.insert('Deals', note.toJson());
    _db.execute("""INSERT INTO Deals (deal, start, end, done) VALUES (
        \"${note.deal}\", \"${Note.dateTimeToString(note.start)}\",
        \"${Note.dateTimeToString(note.end)}\", ${note.done ? 1 : 0})""");
  }

  static void deleteNote(Note note) {
    _db.execute("DELETE FROM Deals WHERE start=${Note.dateTimeToString(note.start)}");
  }

  static Future<List<Note>> downloadAll() async {
    return (await _db.rawQuery("SELECT * FROM Deals")).map((e) => Note.fromJson(e)).toList();
  }
}