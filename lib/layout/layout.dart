import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/modules/sign_in.dart/signin.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        var cubit = InstgramCubit.get(context);
        cubit.showComments = true;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: SvgPicture.asset(
              "assets/instagram.svg",
              height: 35,
              width: 35,
              color: Colors.white,
              fit: BoxFit.fill,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                    onPressed: () {
                      cubit.signOut(context: context, widget: const SignIn());
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
          body: cubit.getData != null
              ? cubit.screens[cubit.currentIndex]
              : Container(),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (v) {
                cubit.changeCurrentIndex(v);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey[500],
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: ""),
              ]),
        );
      },
      listener: (context, state) {},
    );
  }
}
