import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test_task/database/color_model_dao.dart';
import 'package:http/http.dart';

class ColorModel{
  int id;
  String colorName;
  Color colorData;

  ColorModel({
    this.id,
    this.colorName,
    this.colorData,
  });

  factory ColorModel.fromMap(Map<String, dynamic> json) => ColorModel(
    id: json["id"],
    colorName: json["color_name"],
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "color_name" : colorName,
  };

  static sync() async {

    ColorModel _colorModel;

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
          _colorModel = ColorModel.fromMap(jsonShopItem);
          ColorModelDAO().insert(_colorModel);
        }

      }

    } catch (e) {
      print(e);
    }

  }
}