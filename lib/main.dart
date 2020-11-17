import 'package:flutter/material.dart';
import 'package:flutter_test_task/route_generator.dart';

void main() => runApp(TaskApp());

class TaskApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        dividerColor: Colors.transparent,
        primaryColor: Colors.black,
        fontFamily: "Aaargh",
        appBarTheme: AppBarTheme(
          color: Colors.black
        )
      ),
    );
  }

}
