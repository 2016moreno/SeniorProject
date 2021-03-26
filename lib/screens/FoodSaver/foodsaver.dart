import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'package:food_app/screens/SearchRecipes/models/ingredients.dart';
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
            padding: EdgeInsets.all(16),
            child: buildInsertButton(),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: ingredients.map((element) => Text(element)).toList(),
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
          });
        },
      );
}
