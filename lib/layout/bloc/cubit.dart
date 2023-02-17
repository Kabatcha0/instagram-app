import 'dart:developer' show log;
import 'dart:io';
import 'dart:math' show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/models/comments.dart';
import 'package:muslm_instgram/models/post.dart';
import 'package:muslm_instgram/models/user.dart' as f;
import 'package:muslm_instgram/modules/favorites/favorites.dart';
import 'package:muslm_instgram/modules/posts/posts.dart';
import 'package:muslm_instgram/modules/home/home.dart';
import 'package:muslm_instgram/modules/profile/profile.dart';
import 'package:muslm_instgram/modules/search/search.dart';
import 'package:muslm_instgram/shared/local/cache.dart';
import 'package:muslm_instgram/shared/local/const.dart';
import 'package:uuid/uuid.dart';

class InstgramCubit extends Cubit<InstagramStates> {
  InstgramCubit() : super(InstgramInitialState());
  static InstgramCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeCurrentIndex(int v) {
    currentIndex = v;
    emit(InstgramChangeCurrentIndexState());
  }

  List<Widget> screens = [
    Home(),
    Search(),
    Posts(),
    const Favorites(),
    const Profile(),
  ];
  void signOut({required BuildContext context, required Widget widget}) {
    FirebaseAuth.instance.signOut().then((value) {
      navigatorPushReplacement(context: context, widget: widget);
      uiD = "";
      CacheHelper.removeString(key: "uid");
      log(CacheHelper.getString(key: "uid"));
      log(uiD!);
      emit(SignOutState());
    }).catchError((e) {
      e.toString();
    });
  }

  f.User? getData;
  void getUser() {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(uiD)
        .snapshots()
        .listen((event) {
      getData = f.User.fromJson(event.data()!);

      emit(InstgramGetUsersState());
    });
  }

  void sendPosts({
    required String description,
    required String postUrl,
    required String datePublish,
    required List likes,
  }) {
    String postId = const Uuid().v1();
    Post post = Post(
        image: getData!.image,
        description: description,
        uid: uiD!,
        user: getData!.user,
        postId: postId,
        postUrl: postUrl,
        datePublish: datePublish,
        likes: likes);
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uiD)
        // .collection("myPosts")
        .doc(postId)
        .set(post.toMap())
        .then((value) {
      emit(InstgramPostsState());
    }).catchError((e) {
      log(e.toString());
    });
  }

  File? file;
  void imagePickerFromCamera() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        file = File(value.path);
        emit(InstgramCameraState());
      } else {
        return null;
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  void imagePickerFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        file = File(value.path);
        emit(InstgramGalleryState());
      } else {
        return null;
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  String? imageUrl;
  void imageOfPost({
    String? description,
    required String datePublish,
    required List likes,
  }) {
    emit(InstgramLoadingSendPostsState());
    if (file != null) {
      List name = file!.path.split("/");
      int random = Random().nextInt(1000000000);
      FirebaseStorage.instance
          .ref("Posts")
          .child("$random${name.last}")
          .putFile(file!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          imageUrl = value;
          sendPosts(
              description: description ?? "",
              postUrl: imageUrl ?? "",
              datePublish: datePublish,
              likes: likes);
        }).catchError((e) {
          log(e.toString());
        });
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      sendPosts(
          description: description ?? "",
          postUrl: "",
          datePublish: datePublish,
          likes: likes);
    }
  }

  List<Post> getPost = [];
  List<Post> getPostLength = [];

  List getPersonalPost = [];
  List searchPost = [];

  void getPosts() {
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uiD)
        // .collection("myPosts")
        .orderBy("datePublish", descending: true)
        .snapshots()
        .listen((event) {
      getPost = [];
      getPostLength = [];
      searchPost = [];
      for (var element in event.docs) {
        getPost.add(Post.fromJson(element.data()));
        if (element.data()["uid"] != uiD && element.data()["postUrl"] != "") {
          searchPost.add(element.data()["postUrl"]);
          log("$images");
          emit(InstgramFollowUserState());
        }
        if (element.data()["uid"] == uiD) {
          getPostLength.add(Post.fromJson(element.data()));

          if (element.data()["postUrl"] != "") {
            getPersonalPost.add(element.data()["postUrl"]);
          }
        }
        if (element.data()["likes"].contains(uiD)) {
          getLikes.addAll({element.data()["postId"]: true});
        } else {
          getLikes.addAll({element.data()["postId"]: false});
        }
        // getComments(postId: element.reference.id);
      }
    });
  }

  Map<String, bool> getLikes = {};
  void likeThePosts({required String postId, required List likes}) {
    if (likes.contains(uiD)) {
      FirebaseFirestore.instance
          .collection("posts")
          // .doc(uiD)
          // .collection("myPosts")
          .doc(postId)
          .update({
        "likes": FieldValue.arrayRemove([uiD])
      }).then((value) {
        emit(InstgramLikesState());
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(uiD)
          .collection("myPosts")
          .doc(postId)
          .update({
        "likes": FieldValue.arrayUnion([uiD])
      }).then((value) {
        emit(InstgramLikesState());
      }).catchError((e) {
        log(e.toString());
      });
    }
  }

  void uploadImageInComment({
    required String postId,
    required String user,
    required String datePublish,
    required String comment,
    required List likes,
  }) {
    emit(InstgramLoadingImageCommentState());
    if (file != null) {
      List name = file!.path.split("/");
      int random = Random().nextInt(10000000000);
      FirebaseStorage.instance
          .ref("comments")
          .child("$random${name.last}")
          .putFile(file!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          imageComment = value;
          postComments(
              postId: postId,
              user: user,
              datePublish: datePublish,
              comment: comment,
              image: imageComment!,
              likes: likes);
        }).catchError((e) {
          log(e.toString());
        });
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      postComments(
          postId: postId,
          user: user,
          datePublish: datePublish,
          comment: comment,
          image: imageComment ?? "",
          likes: likes);
    }
  }

  String? imageComment;

  void postComments({
    required String postId,
    required String user,
    required String datePublish,
    required String comment,
    String? image,
    required List likes,
  }) {
    String commentId = const Uuid().v1();
    CommentsModel commentsModel = CommentsModel(
        comment: comment,
        uid: uiD!,
        image: image ?? "",
        user: user,
        datePublish: datePublish,
        likes: likes);
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uiD)
        // .collection("myPosts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .set(commentsModel.toMap())
        .then((value) {
      emit(InstgramPostCommentsState());
    }).catchError((e) {
      log(e.toString());
    });
  }

  List<CommentsModel> getComment = [];
  List<int> length = [];
  bool showComments = false;
  void getComments({required String postId}) {
    if (showComments == true) {
      FirebaseFirestore.instance
          .collection("posts")
          // .doc(uiD!)
          // .collection("myPosts")
          .doc(postId)
          .collection("comments")
          .orderBy("datePublish", descending: true)
          .snapshots()
          .listen((event) {
        getComment = [];
        log("messagae");
        for (var element in event.docs) {
          length.add(event.docs.length);
          getComment.add(CommentsModel.fromJson(element.data()));
          emit(InstgramGetCommentsState());
        }
      });
    }
    showComments = false;
  }

  void deleteImagePost({required String postId, required String image}) {
    if (image != "") {
      FirebaseStorage.instance.refFromURL(image).delete().then((value) {
        deletePost(postId: postId);
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      deletePost(postId: postId);
    }
  }

  void deletePost({required String postId}) {
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uiD)
        // .collection("myPosts")
        .doc(postId)
        .delete()
        .then((value) {
      deleteComment(postId: postId);
    }).catchError((e) {
      log(e.toString());
    });
  }

  void deleteComment({required String postId}) {
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uiD)
        // .collection("myPosts")
        .doc(postId)
        .collection("comments")
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
        emit(InstgramDeleteCommentState());
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  List<f.User> filter = [];
  void searchUser({required String textEditingController}) {
    FirebaseFirestore.instance
        .collection("accounts")
        .where("user", isGreaterThanOrEqualTo: textEditingController)
        .get()
        .then((value) {
      filter = [];
      value.docs.forEach((element) {
        log(uiD!);
        if (element.data()["uid"] != uiD) {
          filter.add(f.User.fromJson(element.data()));
          emit(InstgramSearchUserState());
        }
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

// دا لما ادوس وانا بعمل سيرش
  f.User? followPersonUser;
  void followPerson({required int index}) {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(filter[index].uid)
        .snapshots()
        .listen((value) {
      log("message=");
      followPersonUser = f.User.fromJson(value.data()!);
      getPostForAnotherPerson(uid: filter[index].uid);
    });
  }

  List<String> images = [];
  void getPostForAnotherPerson({required String uid}) {
    FirebaseFirestore.instance
        .collection("posts")
        // .doc(uid)
        // .collection("myPosts")
        .get()
        .then((value) {
      images = [];
      for (var element in value.docs) {
        if (element.data()["uid"] == uid) {
          images.add(element.data()["postUrl"]);
          log("$images");
          emit(InstgramFollowUserState());
        }
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

// دا بتاع الفولو
  bool changeFollow = false;
  void following() {
    changeFollow = !changeFollow;
    if (changeFollow == true) {
      FirebaseFirestore.instance.collection("accounts").doc(uiD).update({
        "Following": FieldValue.arrayUnion([followPersonUser!.uid])
      }).then((value) {
        followers();
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      FirebaseFirestore.instance.collection("accounts").doc(uiD).update({
        "Following": FieldValue.arrayRemove([followPersonUser!.uid])
      }).then((value) {
        followers();
      }).catchError((e) {
        log(e.toString());
      });
    }
  }

  void followers() {
    // log("$changeFollow");
    if (changeFollow == true) {
      FirebaseFirestore.instance
          .collection("accounts")
          .doc(followPersonUser!.uid)
          .update({
        "Followers": FieldValue.arrayUnion([uiD])
      }).then((value) {
        log(uiD!);
        emit(InstgramUpdateFollowState());
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      FirebaseFirestore.instance
          .collection("accounts")
          .doc(followPersonUser!.uid)
          .update({
        "Followers": FieldValue.arrayRemove([uiD])
      }).then((value) {
        log("$uiD! ====");
        emit(InstgramUpdateFollowState());
      }).catchError((e) {
        log(e.toString());
      });
    }
  }

  String? editProfileImage;
  void editImage({
    required String username,
    required String phone,
    required String bio,
    required String email,
    required String password,
  }) {
    emit(InstgramEditProfileLoadingState());
    if (file != null) {
      List name = file!.path.split("/");
      int random = Random().nextInt(1000000000);
      FirebaseStorage.instance
          .refFromURL(getData!.image)
          .delete()
          .then((value) {
        FirebaseStorage.instance
            .ref("profile")
            .child("$random" + "${name.last}")
            .putFile(file!)
            .then((v) {
          v.ref.getDownloadURL().then((value) {
            editProfileImage = value;
            editProfile(
                username: username,
                phone: phone,
                bio: bio,
                email: email,
                password: password,
                image: editProfileImage);
          }).catchError((e) {
            log(e.toString());
          });
        }).catchError((e) {
          log(e.toString());
        });
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      editProfile(
        username: username,
        phone: phone,
        bio: bio,
        email: email,
        password: password,
      );
    }
  }

  void editProfile({
    required String username,
    required String phone,
    required String bio,
    required String email,
    required String password,
    String? image,
  }) {
    if (file != null) {
      FirebaseFirestore.instance.collection("accounts").doc(uiD).update({
        "bio": bio,
        "image": image,
        "mail": email,
        "password": password,
        "username": username,
        "phone": phone
      }).then((value) {
        emit(InstgramEditProfileState());
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      FirebaseFirestore.instance.collection("accounts").doc(uiD).update({
        "bio": bio,
        "mail": email,
        "password": password,
        "username": username,
        "phone": phone
      }).then((value) {
        emit(InstgramEditProfileState());
      }).catchError((e) {
        log(e.toString());
      });
    }
  }
}
