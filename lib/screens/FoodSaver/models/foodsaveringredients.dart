class FoodSaverModel {
  int id;
  String title;
  String image;

  FoodSaverModel({this.id, this.title, this.image});

  factory FoodSaverModel.fromMap(Map<String, dynamic> parsedJson) {
    return FoodSaverModel(
      id: parsedJson["id"],
      title: parsedJson["title"],
      image: parsedJson["image"],
    );
  }
}
