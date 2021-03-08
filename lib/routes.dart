import 'package:flutter/widgets.dart';
import 'package:food_app/screens/FoodRecognition/foodrecognition.dart';
import 'package:food_app/screens/routepage/route_page.dart';
import 'package:food_app/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  RoutePage.routeName: (context) => RoutePage(),
  FoodRecognition.routeName: (context) => FoodRecognition(),
};
