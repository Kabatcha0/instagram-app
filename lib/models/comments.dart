class CommentsModel {
  late String comment;
  late String user;
  late String datePublish;
  late List likes = [];
  late String uid;
  late String image;
  CommentsModel({
    required this.comment,
    required this.uid,
    required this.user,
    required this.datePublish,
    required this.likes,
    required this.image,
  });
  CommentsModel.fromJson(Map<String, dynamic> json) {
    comment = json["comment"];
    user = json["user"];
    datePublish = json["datePublish"];
    likes = json["likes"];
    uid = json["uid"];
    image = json["image"];
  }
  Map<String, dynamic> toMap() => {
        "comment": comment,
        "user": user,
        "datePublish": datePublish,
        "uid": uid,
        "likes": likes,
        "image": image
      };
}
