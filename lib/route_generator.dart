import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/pages/page_shop.dart';
import 'package:flutter_test_task/pages/page_shop_item_info.dart';
import 'package:flutter_test_task/pages/page_welcome.dart';
import 'package:flutter_test_task/pages/page_login.dart';
import 'package:flutter_test_task/pages/page_root.dart';

import 'models/models.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => PageRoot());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => PageFirst());
      case "/login":
        if (args is RouteArgs) {
          return MaterialPageRoute(builder: (_) => PageLogin(
            pageName: args.pageName,
          ));
        }
        return _errorRoute(settings.name);
      case "/shop":
        if (args is RouteArgs) {
          return MaterialPageRoute(builder: (_) => PageShop(
            user: args.user,
          ));
        }
        return _errorRoute(settings.name);
      case "/shop_item/info":
        if (args is RouteArgs) {
          return MaterialPageRoute(builder: (_) => PageShopItemInfo(
            shopItem: args.shopItem,
          ));
        }
        return _errorRoute(settings.name);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String route) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Incorrect route: $route)'),
        ),
      );
    });
  }
}