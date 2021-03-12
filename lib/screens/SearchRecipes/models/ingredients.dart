class IngredientModel {
  String url;

  IngredientModel({this.url});

  factory IngredientModel.fromMap(Map<String, dynamic> parsedJson) {
    return IngredientModel(
      url: parsedJson["spoonacularSourceUrl"],
    );
  }
}
