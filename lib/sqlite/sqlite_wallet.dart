import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SqliteWallet {
  Database db;
  String tableWallet = 'wallet';
  String columnId = 'id';
  String columnName = 'name';
  String columnAddress = 'address';

  openSqlite() async {
    // 路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'walletAddress.db');

    // 创建数据库
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableWallet (
            $columnId INTEGER PRIMARY KEY autoincrement, 
            $columnName String, 
            $columnAddress String)
          ''');
        });
  }

  // 增
  Future insert(String name, String address) async {
    String sql =
        "INSERT INTO $tableWallet($columnName,$columnAddress) VALUES('$name','$address')";
    await db.rawInsert(sql);
  }

  // 删
  Future<int> delete(String name) async {
    return await db.rawDelete('DELETE FROM $tableWallet WHERE $columnName = ?', ['$name']);
  }

  //改
  Future<void> update(String name,int id) async {
    await db.rawUpdate('UPDATE $tableWallet SET $columnName = ? WHERE $columnId = ?', ['$name', '$id']);

  }

  // 查
  Future<List<Map>> queryAll() async {
    String sqlQuery = 'SELECT * FROM $tableWallet';
    return await db.rawQuery(sqlQuery);
  }

  //清空
  Future<int> clear() async {
    return await db.delete('$tableWallet');
  }

  // 关闭数据库
  Future close() async {
    await db.close();
  }
}
