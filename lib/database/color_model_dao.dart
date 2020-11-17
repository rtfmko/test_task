import 'package:flutter_test_task/database/core.dart';
import 'package:flutter_test_task/models/color_model.dart';
import 'package:sqflite/sqflite.dart';

class ColorModelDAO {
  final dbProvider = DBProvider.db;

  insert(ColorModel colorModel) async {
    final db = await dbProvider.database;
    var raw = await db.insert("colors", colorModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<ColorModel>> getAll() async {
    final db = await dbProvider.database;
    var res = await db.query("colors");
    List<ColorModel> list = res.isNotEmpty ? res.map((c) => ColorModel.fromMap(c)).toList() : [];
    return list;
  }

}