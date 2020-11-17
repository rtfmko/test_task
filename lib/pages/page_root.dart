import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/models.dart';
import 'package:flutter_test_task/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageRoot extends StatefulWidget {

  @override
  _PageRootState createState() => _PageRootState();

}

class _PageRootState extends State<PageRoot> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
  }

  _initState() async {
    final _prefs = await SharedPreferences.getInstance();

    String _userID = _prefs.getString("user_id") ?? "";
    String _userEmail = _prefs.getString("user_email") ?? "";

    if (_userID != "") {
      RouteArgs _args = RouteArgs(
        user: User(userID: _userID, email: _userEmail),
      );
      Navigator.of(context).pushReplacementNamed(
        "/shop",
        arguments: _args,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(
        "/welcome",
        arguments: "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}