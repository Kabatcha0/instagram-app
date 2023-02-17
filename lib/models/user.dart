class User {
  late String email;
  late String user;
  late String phone;
  late String password;
  late String image;
  late List followers = [];
  late List following = [];
  late int posts;
  late String bio;
  late String uid;
  User(
      {required this.email,
      required this.uid,
      required this.user,
      required this.phone,
      required this.password,
      required this.image,
      required this.followers,
      required this.following,
      required this.posts,
      required this.bio});
  User.fromJson(Map<String, dynamic> json) {
    email = json["mail"];
    user = json["user"];
    phone = json["phone"];
    password = json["password"];
    image = json["image"];
    followers = json["Followers"];
    following = json["Following"];
    posts = json["Posts"];
    bio = json["bio"];
    uid = json["uid"];
  }
  Map<String, dynamic> toMap() => {
        "mail": email,
        "user": user,
        "phone": phone,
        "password": password,
        "image": image,
        "uid": uid,
        "Followers": followers,
        "Following": following,
        "Posts": posts,
        "bio": bio,
      };
}
