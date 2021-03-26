import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'package:food_app/screens/SearchRecipes/models/ingredients.dart';
import 'package:food_app/screens/SearchRecipes/models/recipe.dart';
import 'package:food_app/screens/SearchRecipes/recipe_view.dart';

class SearchRecipe extends StatefulWidget {
  static String routeName = "/searchrecipe";
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  TextEditingController textEditingController = new TextEditingController();

  List<RecipeModel> recipes = new List<RecipeModel>();
  String applicationKey = '54faac17dd374f5fb46e743c18a4c92e';

  getRecipes(String query) async {
    String url =
        "https://api.spoonacular.com/recipes/complexSearch?apiKey=54faac17dd374f5fb46e743c18a4c92e&query=$query";

    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["results"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element);
      recipes.add(recipeModel);
    });

    setState(() {});

    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "What recipe will you choose today?",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Enter either the food you're looking for or even search with ingredients!",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: "Enter Food",
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          if (textEditingController.text.isNotEmpty) {
                            getRecipes(textEditingController.text);
                          } else {
                            print("typing error");
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GridView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10.0,
                  ),
                  children: List.generate(recipes.length, (index) {
                    return GridTile(
                      child: RecipieTile(
                        title: recipes[index].title,
                        imgUrl: recipes[index].image,
                        id: recipes[index].id,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, imgUrl;
  final int id; //add url and desc later

  String foodwebsite;

  var receiver;

  RecipieTile(
      {this.title, this.imgUrl, this.id}); //add this.desc and this.url later

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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
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

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {this.topColor,
      this.bottomColor,
      this.topColorCode,
      this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
