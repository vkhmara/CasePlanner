import 'Deal.dart';
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

  static void addNote(Deal note) {
    _db.execute("""INSERT INTO Deals (deal, start, end, done) VALUES (
        \"${note.deal}\", \"${Deal.dateTimeToString(note.start)}\",
        \"${Deal.dateTimeToString(note.end)}\", ${note.done ? 1 : 0})""");
  }

  static void deleteNote(Deal note) {
    _db.execute("DELETE FROM Deals WHERE start=${Deal.dateTimeToString(note.start)}");
  }

  static void updateDB(List<Deal> list) async {
    await _db.execute('DELETE FROM Deals');
    for (Deal deal in list) {
      addNote(deal);
    }
  }

  static Future<List<Deal>> downloadAll() async {
    return (await _db.rawQuery("SELECT * FROM Deals")).map((e) => Deal.fromJson(e)).toList();
  }
}