import 'dart:convert';
import 'dart:io';

import 'package:flutter_test_task/database/shop_item_dao.dart';
import 'package:http/http.dart';

class ShopItem {

  int id;
  String image;
  String name;
  String description;
  String productCode;
  String category;
  String material;
  String country;
  List<String> color;
  List<String> size;
  bool isFavorite;
  int ratio;
  int ratioCount;
  double amount;
  bool isSale;
  double saleAmount;
  DateTime saleDate;

  ShopItem({
    this.id,
    this.image,
    this.name,
    this.description,
    this.productCode,
    this.category,
    this.material,
    this.country,
    this.color,
    this.size,
    this.isFavorite,
    this.ratio,
    this.ratioCount,
    this.amount,
    this.isSale,
    this.saleAmount,
    this.saleDate,
  });

  factory ShopItem.fromMap(Map<String, dynamic> json) => ShopItem(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    description: json["description"],
    productCode: json["product_code"],
    category: json["category"],
    material: json["material"],
    country: json["country"],
    isFavorite: json["is_favorite"] == null
        ? false
        : json["is_favorite"] is int
            ? json["is_favorite"] == 1 ? true : false
            : json["is_favorite"],
    ratio: json["ratio"],
    ratioCount: json["ratio_count"],
    amount: json["amount"] != null
        ? json["amount"].toDouble()
        : 0.00,
    isSale: json["is_sale"] == null
        ? false
        : json["is_sale"] is int
            ? json["is_sale"] == 1 ? true : false
            : json["is_sale"],
    saleAmount: json["sale_amount"] != null
        ? json["sale_amount"].toDouble()
        : 0.00,
    saleDate: json["sale_date"] != null
        ? DateTime.parse(json["sale_date"])
        : null,
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "image" : image,
    "name" : name,
    "description" : description,
    "product_code" : productCode,
    "category" : category,
    "material" : material,
    "country" : country,
    "is_favorite" : isFavorite == null ? 0 : isFavorite ? 1 : 0,
    "ratio" : ratio,
    "ratio_count" : ratioCount,
    "amount" : amount,
    "is_sale" : isSale == null ? 0 : isSale ? 1 : 0,
    "sale_amount" : saleAmount,
    "sale_date" : saleDate != null ? saleDate.toIso8601String() : null,

  };

  static sync() async {

    ShopItem _shopItem;

    final String _url = 'https://testtask-dbb6e.firebaseio.com/shop_item.json';

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
          _shopItem = ShopItem.fromMap(jsonShopItem);
          ShopItemDAO().insert(_shopItem);
        }

      }

    } catch (e) {
      print(e);
    }

  }

}