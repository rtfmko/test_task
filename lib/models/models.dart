import 'package:flutter_test_task/models/shop_item.dart';
import 'package:flutter_test_task/models/user.dart';

class RouteArgs {
  String pageName;
  User user;
  ShopItem shopItem;

  RouteArgs({
    this.pageName,
    this.user,
    this.shopItem,
  });

}