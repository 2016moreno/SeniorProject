import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import 'package:food_app/screens/FoodRecognition/models/foodrecognitioningredientsmodel.dart';

import 'package:food_app/screens/FoodRecognition/foodrecognitionviewer.dart';

const String yolo = "Tiny YOLOv2";

class FoodRecognition extends StatefulWidget {
  static String routeName = "/foodrecognition";
  @override
  _FoodRecognition createState() => _FoodRecognition();
}

class _FoodRecognition extends State<FoodRecognition> {
  List<dynamic> ingredients = List();
  String help;
  var helparray = [];
  bool busy = false;

  @override
  void initState() {
    super.initState();
    busy = true;

    tfliteloadmodel().then((val) {
      setState(() {
        busy = false;
      });
    });
  }

  tfliteloadmodel() async {
    Tflite.close();
    String loadModels;
    loadModels = await Tflite.loadModel(
      model: "assets/tflite/yolov2_tiny.tflite",
      labels: "assets/tflite/yolov2_tiny.txt",
    );
    print(loadModels);
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      busy = true;
    });
    tempImagePrediction(image);
  }

  File loadimage;
  double imagesideW;
  double imagetallH;

  tempImagePrediction(File tempImage) async {
    await tempImageYolov2(tempImage);

    FileImage(tempImage)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo tempimageinfo, bool _) {
          setState(() {
            imagesideW = tempimageinfo.image.width.toDouble();
            imagetallH = tempimageinfo.image.height.toDouble();
          });
        })));

    setState(() {
      loadimage = tempImage;
      busy = false;
    });
  }

  List imagerec;
  List<dynamic> imagearray = [];

  tempImageYolov2(File tempImage) async {
    var tempImageRec = await Tflite.detectObjectOnImage(
        path: tempImage.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      imagerec = tempImageRec;
      imagearray = tempImageRec;
      print(imagearray);
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (imagerec == null) return [];
    if (imagesideW == null || imagetallH == null) return [];

    double x = screen.width;
    double y = imagetallH / imagetallH * screen.width;

    Color blue = Colors.red;

    return imagerec.map((tempImageRecognition) {
      help = "${tempImageRecognition["detectedClass"]}";
      helparray.add(help);
      return Positioned(
        left: tempImageRecognition["rect"]["x"] * x,
        top: tempImageRecognition["rect"]["y"] * y,
        width: tempImageRecognition["rect"]["w"] * x,
        height: tempImageRecognition["rect"]["h"] * y,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: blue,
            width: 3,
          )),
          child: Text(
            "${tempImageRecognition["detectedClass"]} ${(tempImageRecognition["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<FoodRecognitionIngredientsModel> foodsaverrecipes =
      new List<FoodRecognitionIngredientsModel>();
  String applicationKey = '54faac17dd374f5fb46e743c18a4c92e';

  getRecipesIngredients(var query) async {
    query = query.toString();
    String url =
        "https://api.spoonacular.com/recipes/findByIngredients?apiKey=$applicationKey&ingredients=$query&number=10&ranking2";

    var response = await http.get(url);
    List<dynamic> jsonData = jsonDecode(response.body);

    jsonData.forEach((element) {
      FoodRecognitionIngredientsModel foodrecognitionModel =
          new FoodRecognitionIngredientsModel();
      foodrecognitionModel = FoodRecognitionIngredientsModel.fromMap(element);
      foodsaverrecipes.add(foodrecognitionModel);
    });

    // jsonData["id"].forEach((element) {
    //   foodrecognitionModel foodsaverModel = new FoodSaverModel();
    //   foodsaverModel = FoodSaverModel.fromMap(element);
    //   foodsaverrecipes.add(foodsaverModel);
    // });

    // jsonData["title"].forEach((element) {
    //   FoodSaverModel foodsaverModel = new FoodSaverModel();
    //   foodsaverModel = FoodSaverModel.fromMap(element);
    //   foodsaverrecipes.add(foodsaverModel);
    // });

    // jsonData["image"].forEach((element) {
    //   FoodSaverModel foodsaverModel = new FoodSaverModel();
    //   foodsaverModel = FoodSaverModel.fromMap(element);
    //   foodsaverrecipes.add(foodsaverModel);
    // });

    setState(() {});

    print("${foodsaverrecipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child:
          loadimage == null ? Text("No Image Selected") : Image.file(loadimage),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Food Recognition to Recipe",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color(0xFFFF7643),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.image),
            backgroundColor: Color(0xFFFF7643),
            tooltip: "Pick Image from gallery",
            onPressed: selectFromImagePicker,
          ),
          body: Stack(
            children: stackChildren,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(100, 650, 0, 0),
          child: buildSearchButton(),
        ),
        //gridview
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // RaisedButton(onPressed: onPressed)
              // Expanded(
              //   child: Container(),
              // ),
              //
              Padding(padding: EdgeInsets.all(200)),

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
        ),
      ],
    );
  }

  Widget buildSearchButton() => RaisedButton(
        child: Text(
          'Search for Recipes',
          style: TextStyle(fontSize: 20),
        ),
        color: Color(0xFFFF7643),
        onPressed: () async {
          await getRecipesIngredients(helparray);
          print(
              "https://api.spoonacular.com/recipes/findByIngredients?apiKey=54faac17dd374f5fb46e743c18a4c92e&ingredients=$helparray&number=10&ranking2");
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

  getIngredients(String recipeid) async {
    // String url =
    //     "https://api.spoonacular.com/recipes/$recipeid/information?apiKey=$apikey";

    // print(url);

    var response = await http.get(
        "https://api.spoonacular.com/recipes/$recipeid/information?apiKey=$apikey");
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    ingredients = jsonData["sourceUrl"];

    setState(() {});

    print("${ingredients.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            var recipeid = widget.id.toString();
            print(widget.id.toString());
            await getIngredients(recipeid);

            print(ingredients.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodRecognitionView(
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
                  // decoration: BoxDecoration(padding: ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              inherit: true,
                              fontSize: 20.0,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(-1.5, -1.5),
                                    color: Colors.black),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(1.5, -1.5),
                                    color: Colors.black),
                                Shadow(
                                    // topRight
                                    offset: Offset(1.5, 1.5),
                                    color: Colors.black),
                                Shadow(
                                    // topLeft
                                    offset: Offset(-1.5, 1.5),
                                    color: Colors.black),
                              ]),
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
