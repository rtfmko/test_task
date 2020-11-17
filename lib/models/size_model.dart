import 'dart:convert';
import 'dart:io';

import 'package:flutter_test_task/database/size_model_dao.dart';
import 'package:http/http.dart';

class SizeModel {
  int id;
  String size;

  SizeModel({
    this.id,
    this.size,
  });

  factory SizeModel.fromMap(Map<String, dynamic> json) => SizeModel(
    id: json["id"],
    size: json["size"],
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "size" : size,
  };

  static sync() async {

    SizeModel _sizeModel;

    final String _url = 'https://testtask-dbb6e.firebaseio.com/colors.json';

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    try {
      Response response = await get(
        _url,
        headers: headers,
      );

      if(response.statusCode == 200){
        var jsonData = json.decode(response.body);

        if(jsonData == null) {
          return;
        }

        for(var jsonShopItem in jsonData){
          _sizeModel = SizeModel.fromMap(jsonShopItem);
          SizeModelDAO().insert(_sizeModel);
        }

      }

    } catch (e) {
      print(e);
    }

  }

}