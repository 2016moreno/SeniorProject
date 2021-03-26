import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'package:food_app/screens/FoodSaver/models/foodsaveringredients.dart';
import 'package:food_app/screens/SearchRecipes/models/recipe.dart';
import 'package:food_app/screens/SearchRecipes/recipe_view.dart';

class FoodSaver extends StatefulWidget {
  static String routeName = "/foodsaver";

  @override
  _FoodSaverState createState() => _FoodSaverState();
}

class _FoodSaverState extends State<FoodSaver> {
  List<String> ingredients = List();
  String temp;
  var arr = [];

  List<FoodSaverModel> foodsaverrecipes = new List<FoodSaverModel>();
  String applicationKey = '54faac17dd374f5fb46e743c18a4c92e';

  getRecipesIngredients(var query) async {
    query = query.toString();
    String url =
        "https://api.spoonacular.com/recipes/findByIngredients?apiKey=54faac17dd374f5fb46e743c18a4c92e&ingredients=$query&number=10&ranking2";

    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["id"].forEach((element) {
      FoodSaverModel foodsaverModel = new FoodSaverModel();
      foodsaverModel = FoodSaverModel.fromMap(element);
      foodsaverrecipes.add(foodsaverModel);
    });

    jsonData["title"].forEach((element) {
      FoodSaverModel foodsaverModel = new FoodSaverModel();
      foodsaverModel = FoodSaverModel.fromMap(element);
      foodsaverrecipes.add(foodsaverModel);
    });

    jsonData["image"].forEach((element) {
      FoodSaverModel foodsaverModel = new FoodSaverModel();
      foodsaverModel = FoodSaverModel.fromMap(element);
      foodsaverrecipes.add(foodsaverModel);
    });

    setState(() {});

    print("${foodsaverrecipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert ingredients below"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Insert 1 ingredient at a time'),
              onChanged: (str) {
                temp = str;
              },
            ),
          ),
          // RaisedButton(onPressed: onPressed)
          // Expanded(
          //   child: Container(),
          // ),
          Container(
            child: buildInsertButton(),
          ),
          Container(
            child: buildSearchButton(),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: ingredients.map((element) => Text(element)).toList(),
          ),
          GridView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10.0,
            ),
            children: List.generate(foodsaverrecipes.length, (index) {
              return GridTile(
                child: RecipieTile(
                  title: foodsaverrecipes[index].title,
                  imgUrl: foodsaverrecipes[index].image,
                  id: foodsaverrecipes[index].id,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildInsertButton() => RaisedButton(
        child: Text(
          'Insert Ingredient',
          style: TextStyle(fontSize: 20),
        ),
        color: Color(0xFFFF7643),
        onPressed: () {
          setState(() {
            ingredients.add(temp);
            arr.add(temp);
          });
        },
      );

  Widget buildSearchButton() => RaisedButton(
        child: Text(
          'Search for Recipes',
          style: TextStyle(fontSize: 20),
        ),
        color: Color(0xFFFF7643),
        onPressed: () {
          getRecipesIngredients(arr);
          print(
              "https://api.spoonacular.com/recipes/findByIngredients?apiKey=54faac17dd374f5fb46e743c18a4c92e&ingredients=$arr&number=10&ranking2");
        },
      );
}

class RecipieTile extends StatefulWidget {
  final String title, imgUrl;
  final int id;

  RecipieTile({this.title, this.imgUrl, this.id});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var apikey = '54faac17dd374f5fb46e743c18a4c92e&';
  //"https://api.spoonacular.com/recipes/$foodurl/information?apiKey=54faac17dd374f5fb46e743c18a4c92e&"

  String ingredients;

  getIngredients(String recipeurl) async {
    String url =
        "https://api.spoonacular.com/recipes/$recipeurl/information?apiKey=$apikey";

    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    ingredients = jsonData["spoonacularSourceUrl"];

    setState(() {});

    print("${ingredients.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            var recipeurl = widget.id.toString();
            await getIngredients(recipeurl);

            print(ingredients.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeView(
                          postUrl: ingredients,
                        )));
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
