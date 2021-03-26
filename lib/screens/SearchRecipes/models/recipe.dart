class RModel {
  int id;
  String title;
  String image;

  RModel({this.id, this.title, this.image});

  factory RModel.fromMap(Map<String, dynamic> parsedJson) {
    return RModel(
      id: parsedJson["id"],
      title: parsedJson["title"],
      image: parsedJson["image"],
    );
  }
}
