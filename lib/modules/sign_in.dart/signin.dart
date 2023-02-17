import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/layout.dart';
import 'package:muslm_instgram/modules/sign_in.dart/cubitsingin/cubit_signin.dart';
import 'package:muslm_instgram/modules/sign_in.dart/cubitsingin/states_signin.dart';
import 'package:muslm_instgram/modules/sign_up.dart/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  TextEditingController controllerMail = TextEditingController();

  TextEditingController controllerPass = TextEditingController();
  @override
  void dispose() {
    controllerMail.dispose();
    controllerPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramSignInCubit, SignInStates>(
      builder: (context, state) {
        var cubit = InstgramSignInCubit.get(context);
        return Scaffold(
          body: SafeArea(
              child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  "assets/instagram.svg",
                  height: 55,
                  width: 55,
                  color: Colors.white,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: textFromField(
                      hint: "Email",
                      onChange: (v) {
                        setState(() {});
                        return null;
                      },
                      controller: controllerMail,
                      function: (v) {
                        if (v!.isEmpty) {
                          return "Please Enter your mail";
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: textFromField(
                      onChange: (v) {
                        setState(() {});
                        return null;
                      },
                      show: true,
                      hint: "Password",
                      controller: controllerPass,
                      function: (v) {
                        if (v!.isEmpty) {
                          return "Please Enter your pass";
                        }
                        if (v.length < 6) {
                          return "Password must greater than 6 ";
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (controllerMail.text.isEmpty || controllerPass.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Stack(
                      children: [
                        button(
                            color: Colors.blue, text: "LogIn", function: () {}),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.6)),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.grey[800],
                                      content: Text(
                                          "Plz enter your pass and mail",
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (state is SignInLoadingState)
                  const SizedBox(
                    height: 10,
                  ),
                if (state is SignInLoadingState)
                  const LinearProgressIndicator(),
                if (state is SignInLoadingState)
                  const SizedBox(
                    height: 10,
                  ),
                if (controllerMail.text.isNotEmpty &&
                    controllerPass.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: button(
                        color: Colors.blue,
                        text: "LogIn",
                        function: () {
                          if (form.currentState!.validate()) {
                            cubit.auth(
                                mail: controllerMail.text.trim(),
                                password: controllerPass.text);
                          }
                          return null;
                        }),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Forget Your Email or Pass ? ",
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Some Help",
                          style: TextStyle(
                              color: Colors.blue[200],
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 40,
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account ? ",
                        style: TextStyle(color: Colors.grey[500], fontSize: 15),
                      ),
                      InkWell(
                        onTap: () {
                          navigator(context: context, widget: const SignUp());
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.blue[200],
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        );
      },
      listener: (context, state) {
        if (state is SignInSuccessState) {
          navigatorPushReplacement(context: context, widget: const Layout());
        }
      },
    );
  }
}
