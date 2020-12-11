import 'dart:developer';

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
    _db = await openDatabase(path, version: 1,
        onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          await db.execute("""CREATE TABLE IF NOT EXISTS Deals (
          id INT AUTO_INCREMENT PRIMARY KEY,
          deal VARCHAR(200),
          start DATETIME,
          end DATETIME,
          done BIT
          )""");
        });
    log('database init');
  }

  static Future<void> deleteDeal(Deal deal) async {
    await _db.execute("DELETE FROM Deals WHERE start=\"${Deal.dateTimeToString(
        deal.start)}\"");
    log('database delete');
  }

  static Future<void> editDeal(Deal oldDeal, Deal newDeal) async {
    await _db.execute("""UPDATE Deals
    SET deal=\"${newDeal.deal}\",
    start=\"${Deal.dateTimeToString(newDeal.start)}\",
    end=\"${Deal.dateTimeToString(newDeal.end)}\",
    done=${newDeal.done ? 1 : 0}
    WHERE start = \"${Deal.dateTimeToString(oldDeal.start)}\"""");
    log('database edit');
  }

  static Future<void> addDeal(Deal deal) async {
    await _db.execute("""INSERT INTO Deals (deal, start, end, done) VALUES (
        \"${deal.deal}\", \"${Deal.dateTimeToString(deal.start)}\",
        \"${Deal.dateTimeToString(deal.end)}\", ${deal.done ? 1 : 0})""");
    log('database add');
  }

  static Future<void> updateDB(List<Deal> list) async {
    await _db.execute("DELETE FROM Deals");
    for (Deal deal in list) {
      await addDeal(deal);
    }
  }

  static Future<List<Deal>> downloadAll() async {
    return (await _db.rawQuery("SELECT * FROM Deals")).map((e) =>
        Deal.fromJson(e)).toList();
  }
}