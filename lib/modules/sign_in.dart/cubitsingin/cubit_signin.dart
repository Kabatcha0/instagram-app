import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/modules/sign_in.dart/cubitsingin/states_signin.dart';
import 'package:muslm_instgram/shared/local/cache.dart';
import 'package:muslm_instgram/shared/local/const.dart';

class InstgramSignInCubit extends Cubit<SignInStates> {
  InstgramSignInCubit() : super(SignInInitialState());
  static InstgramSignInCubit get(context) => BlocProvider.of(context);
  void auth({
    required String mail,
    required String password,
  }) {
    uiD = "";
    emit(SignInLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: password)
        .then((value) {
      uiD = value.user!.uid;

      CacheHelper.setString(key: "uid", value: uiD!);
      emit(SignInSuccessState());
    }).catchError((e) {
      log(e.toString());
    });
  }
}
