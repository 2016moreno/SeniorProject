class FoodRecognitionIngredientsModel {
  int id;
  String title;
  String image;

  FoodRecognitionIngredientsModel({this.id, this.title, this.image});

  factory FoodRecognitionIngredientsModel.fromMap(
      Map<String, dynamic> parsedJson) {
    return FoodRecognitionIngredientsModel(
      id: parsedJson["id"],
      title: parsedJson["title"],
      image: parsedJson["image"],
    );
  }
}
