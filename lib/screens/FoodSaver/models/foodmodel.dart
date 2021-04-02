class FoodModel {
  String url;

  FoodModel({this.url});

  factory FoodModel.fromMap(Map<String, dynamic> parsedJson) {
    return FoodModel(
      url: parsedJson["spoonacularSourceUrl"],
    );
  }
}
