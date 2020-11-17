import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE shop_item ("
          "id INTEGER,"
          "image TEXT,"
          "name TEXT,"
          "description TEXT,"
          "product_code TEXT,"
          "category TEXT,"
          "material TEXT,"
          "country TEXT,"
          "is_favorite BIT,"
          "ratio INTEGER,"
          "ratio_count INTEGER,"
          "amount DOUBLE,"
          "is_sale BIT,"
          "sale_amount DOUBLE,"
          "sale_date TEXT,"
          "UNIQUE (id) ON CONFLICT REPLACE,"
          "PRIMARY KEY (id)"
          ")");

      await db.execute("CREATE TABLE colors ("
          "id INTEGER PRIMARY KEY,"
          "color_name TEXT,"
          "color_data TEXT"
          ")");

      await db.execute("CREATE TABLE size ("
          "id INTEGER PRIMARY KEY,"
          "size TEXT"
          ")");

      await db.execute("CREATE TABLE relation_color_shop_item ("
          "shop_item_id INTEGER,"
          "color_id INTEGER,"
          "UNIQUE (shop_item_id, color_id) ON CONFLICT REPLACE,"
          "FOREIGN KEY (shop_item_id) REFERENCES shop_item(id),"
          "FOREIGN KEY (color_id) REFERENCES colors(id),"
          "PRIMARY KEY (shop_item_id, color_id)"
          ")");

      await db.execute("CREATE TABLE relation_size_shop_item ("
          "shop_item_id INTEGER,"
          "size_id INTEGER,"
          "UNIQUE (shop_item_id, size_id) ON CONFLICT REPLACE,"
          "FOREIGN KEY (shop_item_id) REFERENCES shop_item(id),"
          "FOREIGN KEY (size_id) REFERENCES size(id),"
          "PRIMARY KEY (shop_item_id, size_id)"
          ")");
    });
  }
}