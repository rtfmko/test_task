import 'package:flutter_test_task/database/core.dart';
import 'package:flutter_test_task/models/shop_item.dart';
import 'package:sqflite/sqflite.dart';

class ShopItemDAO {
  final dbProvider = DBProvider.db;

  insert(ShopItem shopItem) async {
    final db = await dbProvider.database;
    var raw = await db.insert("shop_item", shopItem.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<ShopItem>> getAll() async {
    final db = await dbProvider.database;
    var res = await db.query("shop_item");
    List<ShopItem> list = res.isNotEmpty ? res.map((c) => ShopItem.fromMap(c)).toList() : [];
    return list;
  }

  Future setFavorite(int id, bool value) async {
    final db = await dbProvider.database;
    var res = await db.rawUpdate("UPDATE shop_item SET is_favorite = ? WHERE id = ?", [value ? 1 : 0, id]);
    print(res);
  }

}