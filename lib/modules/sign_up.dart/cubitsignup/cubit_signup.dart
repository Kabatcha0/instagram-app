import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslm_instgram/models/user.dart' as f;
import 'package:muslm_instgram/modules/sign_up.dart/cubitsignup/states_signup.dart';
import 'package:muslm_instgram/shared/local/cache.dart';
import 'package:muslm_instgram/shared/local/const.dart';

class InstgramSignUpCubit extends Cubit<InstgramSignUpStates> {
  InstgramSignUpCubit() : super(InstgramSignUpIntialState());
  static InstgramSignUpCubit get(context) => BlocProvider.of(context);

  void createAuth(
      {required String username,
      required String mail,
      required String password,
      required String phone,
      File? file}) {
    emit(InstgramLoadingUIDState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: mail, password: password)
        .then((value) {
      uiD = value.user!.uid;
      CacheHelper.setString(key: "uid", value: uiD!);

      saveProfileImage(
          file: file!,
          username: username,
          mail: mail,
          password: password,
          phone: phone,
          uid: value.user!.uid);
    }).catchError((e) {
      log(e.toString());
    });
  }

  void fireStore(
      {required String username,
      required String mail,
      required String password,
      required String phone,
      required String uid,
      String bio = "Hello to My App"}) {
    f.User user = f.User(
        uid: uid,
        email: mail,
        user: username,
        phone: phone,
        password: password,
        image: urlProfileImage ??
            "https://mymodernmet.com/wp/wp-content/uploads/2021/12/kristina-makeeva-eoy-photo-1.jpeg",
        followers: [],
        following: [],
        posts: 0,
        bio: bio);
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(uid)
        .set(user.toMap())
        .then((value) {
      emit(InstgramFirestoreState());
    }).catchError((e) {
      log(e.toString());
    });
  }

  File? file;
  void pickPersonalPhoto() {
    file = null;
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        file = File(value.path);
        emit(InstgramPersonalPhotoState());
      } else {
        return null;
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  void saveProfileImage({
    required File file,
    required String username,
    required String mail,
    required String password,
    required String phone,
    required String uid,
  }) {
    List name = file.path.split("/");
    int random = Random().nextInt(1000000000);

    FirebaseStorage.instance
        .ref("profile")
        .child("$random+${name.last}")
        .putFile(file)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        urlProfileImage = value;
        log("=================message===================");
        log("$urlProfileImage");
        log("message");
        fireStore(
            username: username,
            mail: mail,
            password: password,
            phone: phone,
            uid: uid);
        emit(InstgramSaveUrlImageState());
      }).catchError((e) {
        log(e.toString());
      }).catchError((e) {
        log(e.toString());
      });
    });
  }

  String? urlProfileImage;
}
