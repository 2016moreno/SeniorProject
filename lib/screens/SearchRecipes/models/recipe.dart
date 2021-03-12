class RecipeModel {
  int id;
  String title;
  String image;

  RecipeModel({this.id, this.title, this.image});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
      id: parsedJson["id"],
      title: parsedJson["title"],
      image: parsedJson["image"],
    );
  }
}
