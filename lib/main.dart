import 'package:flutter/material.dart';
import 'package:food_app/routes.dart';
import 'package:food_app/screens/splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme(
              headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
            )),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
