import 'package:flutter_test_task/database/core.dart';
import 'package:flutter_test_task/models/size_model.dart';
import 'package:sqflite/sqflite.dart';

class SizeModelDAO {
  final dbProvider = DBProvider.db;

  insert(SizeModel sizeModel) async {
    final db = await dbProvider.database;
    var raw = await db.insert("size", sizeModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<SizeModel>> getAll() async {
    final db = await dbProvider.database;
    var res = await db.query("size");
    List<SizeModel> list = res.isNotEmpty ? res.map((c) => SizeModel.fromMap(c)).toList() : [];
    return list;
  }

}