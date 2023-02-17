import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/layout/layout.dart';
import 'package:muslm_instgram/modules/profile/profile.dart';

class EditProfile extends StatelessWidget {
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        var cubit = InstgramCubit.get(context);
        username.text = cubit.getData!.user;
        phone.text = cubit.getData!.phone;
        bio.text = cubit.getData!.bio;
        email.text = cubit.getData!.email;
        password.text = cubit.getData!.password;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  textFromField(
                      hint: "username",
                      controller: username,
                      function: (v) {
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  textFromField(
                      hint: "password",
                      controller: password,
                      function: (v) {
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  textFromField(
                      hint: "bio",
                      controller: bio,
                      function: (v) {
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  textFromField(
                      hint: "email",
                      controller: email,
                      function: (v) {
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  textFromField(
                      hint: "phone",
                      controller: phone,
                      function: (v) {
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  button(
                      color: Colors.blue,
                      text: "Upload",
                      function: () {
                        show(context, () {
                          cubit.imagePickerFromCamera();
                          Navigator.pop(context);
                        }, () {
                          cubit.imagePickerFromGallery();
                          Navigator.pop(context);
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  button(
                      color: Colors.blue,
                      text: "Save",
                      function: () {
                        cubit.editImage(
                            username: username.text,
                            phone: phone.text,
                            bio: bio.text,
                            email: email.text,
                            password: password.text);
                      }),
                  if (state is InstgramEditProfileLoadingState)
                    const SizedBox(
                      height: 15,
                    ),
                  if (state is InstgramEditProfileLoadingState)
                    const LinearProgressIndicator()
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is InstgramEditProfileState) {
          username.text = "";
          phone.text = "";
          bio.text = "";
          email.text = "";
          password.text = "";
          InstgramCubit.get(context).file = null;
          FocusScope.of(context).unfocus();
          navigator(context: context, widget: const Layout());
        }
      },
    );
  }
}
