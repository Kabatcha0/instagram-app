import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/layout.dart';
import 'package:muslm_instgram/modules/sign_in.dart/cubitsingin/cubit_signin.dart';
import 'package:muslm_instgram/modules/sign_in.dart/signin.dart';
import 'package:muslm_instgram/shared/blocobserver.dart';
import 'package:muslm_instgram/shared/local/cache.dart';
import 'package:muslm_instgram/shared/local/const.dart';

import 'modules/sign_up.dart/cubitsignup/cubit_signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  uiD = CacheHelper.getString(key: "uid");
  log("$uiD");
  runApp(MyApp(uid: uiD));
}

class MyApp extends StatelessWidget {
  String? uid;
  MyApp({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InstgramSignInCubit()),
        BlocProvider(create: (context) => InstgramSignUpCubit()),
        BlocProvider(
            create: (context) => InstgramCubit()
              ..getUser()
              ..getPosts()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram App',
        theme: ThemeData.dark(),
        home: uid == null ? const SignIn() : const Layout(),
      ),
    );
  }
}
