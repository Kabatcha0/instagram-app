import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/layout.dart';
import 'package:muslm_instgram/modules/sign_in.dart/signin.dart';
import 'package:muslm_instgram/modules/sign_up.dart/cubitsignup/cubit_signup.dart';
import 'package:muslm_instgram/modules/sign_up.dart/cubitsignup/states_signup.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  TextEditingController controllerMail = TextEditingController();

  TextEditingController controllerPass = TextEditingController();

  TextEditingController controllerUser = TextEditingController();

  TextEditingController controllerPhone = TextEditingController();

  @override
  void dispose() {
    controllerMail.dispose();
    controllerPass.dispose();
    controllerUser.dispose();
    controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramSignUpCubit, InstgramSignUpStates>(
        builder: (context, state) {
      var cubit = InstgramSignUpCubit.get(context);
      return Scaffold(
        body: SafeArea(
            child: Form(
          key: form,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      circleAvatar(
                          photo: cubit.file,
                          file: cubit.file != null ? true : false,
                          raduis: 60,
                          image:
                              "https://mymodernmet.com/wp/wp-content/uploads/2021/12/kristina-makeeva-eoy-photo-1.jpeg"),
                      InkWell(
                        onTap: () {
                          cubit.pickPersonalPhoto();
                        },
                        child: const Icon(
                          Icons.camera_alt,
                        ),
                      )
                    ],
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
                        controller: controllerMail,
                        onChange: (v) {
                          setState(() {});
                          return null;
                        },
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
                        hint: "Password",
                        controller: controllerPass,
                        onChange: (v) {
                          setState(() {});
                          return null;
                        },
                        show: true,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: textFromField(
                        hint: "Username",
                        controller: controllerUser,
                        onChange: (v) {
                          setState(() {});
                          return null;
                        },
                        function: (v) {
                          if (v!.isEmpty) {
                            return "Please Enter your Username";
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: textFromField(
                        type: TextInputType.phone,
                        hint: "Phone",
                        onChange: (v) {
                          setState(() {});
                          return null;
                        },
                        controller: controllerPhone,
                        function: (v) {
                          if (v!.isEmpty) {
                            return "Please Enter your Phone";
                          }
                          if (v.length < 6 || v.length > 11) {
                            return "Password must greater than 6 and leaster then 12 ";
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (controllerMail.text.isEmpty ||
                      controllerPhone.text.isEmpty ||
                      controllerUser.text.isEmpty ||
                      controllerPass.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Stack(
                        children: [
                          button(
                              color: Colors.blue,
                              text: "SignUp",
                              function: () {}),
                          Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                    ),
                  if (state is InstgramLoadingUIDState)
                    const SizedBox(
                      height: 10,
                    ),
                  if (state is InstgramLoadingUIDState)
                    const LinearProgressIndicator(),
                  if (state is InstgramLoadingUIDState)
                    const SizedBox(
                      height: 10,
                    ),
                  if (controllerMail.text.isNotEmpty &&
                      controllerPass.text.isNotEmpty &&
                      controllerPhone.text.isNotEmpty &&
                      controllerUser.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: button(
                          color: Colors.blue,
                          text: "SignUp",
                          function: () {
                            if (form.currentState!.validate()) {
                              cubit.createAuth(
                                file: cubit.file,
                                username: controllerUser.text.trim(),
                                mail: controllerMail.text.trim(),
                                password: controllerPass.text,
                                phone: controllerPhone.text.trim(),
                              );
                            }
                            return null;
                          }),
                    ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You have account ? ",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                        InkWell(
                          onTap: () {
                            navigator(context: context, widget: const SignIn());
                          },
                          child: Text(
                            "SignIn",
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
            ),
          ),
        )),
      );
    }, listener: (context, state) {
      if (state is InstgramFirestoreState) {
        navigatorPushReplacement(context: context, widget: const Layout());
      }
    });
  }
}
