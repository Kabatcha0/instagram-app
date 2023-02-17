class Post {
  late String description;
  late String user;
  late String postId;
  late String postUrl;
  late String datePublish;
  late List likes = [];
  late String uid;
  late String image;

  Post({
    required this.description,
    required this.uid,
    required this.user,
    required this.postId,
    required this.postUrl,
    required this.datePublish,
    required this.likes,
    required this.image,
  });
  Post.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    user = json["user"];
    postId = json["postId"];
    postUrl = json["postUrl"];
    datePublish = json["datePublish"];
    likes = json["likes"];
    uid = json["uid"];
    image = json["image"];
  }
  Map<String, dynamic> toMap() => {
        "description": description,
        "user": user,
        "postId": postId,
        "postUrl": postUrl,
        "datePublish": datePublish,
        "uid": uid,
        "likes": likes,
        "image": image
      };
}
