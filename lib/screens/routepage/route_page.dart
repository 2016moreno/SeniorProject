import 'package:flutter/material.dart';
import 'package:food_app/screens/FoodSaver/foodsaver.dart';
import 'package:food_app/screens/SearchRecipes/searchrecipe.dart';
import 'package:food_app/screens/routepage/route_page.dart';
import 'package:food_app/size_config.dart';
import 'package:food_app/screens/FoodRecognition/foodrecognition.dart';

class RoutePage extends StatelessWidget {
  static String routeName = "/route_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a catagory"),
      ),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
              width: 300,
              height: getProportionateScreenHeight(56),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Color(0xFFFF7643),
                onPressed: () {
                  Navigator.pushNamed(context, FoodRecognition.routeName);
                },
                child: Text(
                  "Food Recognition to Recipe",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 300,
              height: getProportionateScreenHeight(56),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Color(0xFFFF7643),
                onPressed: () {
                  Navigator.pushNamed(context, SearchRecipe.routeName);
                },
                child: Text(
                  "Search for Recipes",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 300,
              height: getProportionateScreenHeight(56),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Color(0xFFFF7643),
                onPressed: () {
                  Navigator.pushNamed(context, FoodSaver.routeName);
                },
                child: Text(
                  "Ingredients to Recipe",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
