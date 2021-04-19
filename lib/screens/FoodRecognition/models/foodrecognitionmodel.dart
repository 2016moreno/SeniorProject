class FoodRecognitionModel {
  String url;

  FoodRecognitionModel({this.url});

  factory FoodRecognitionModel.fromMap(Map<String, dynamic> parsedJson) {
    return FoodRecognitionModel(
      url: parsedJson["spoonacularSourceUrl"],
    );
  }
}
