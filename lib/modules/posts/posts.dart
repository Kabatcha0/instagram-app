import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';

class Posts extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  Posts({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
        builder: (context, state) {
      var cubit = InstgramCubit.get(context);
      return cubit.getData != null
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(cubit.getData!.image),
                          radius: 30,
                        ),
                        textFromField(
                            maxLines: 4,
                            width: 260,
                            hint: "Write a post",
                            controller: textEditingController,
                            function: (v) {
                              return null;
                            }),
                        IconButton(
                            onPressed: () {
                              show(context, () {
                                cubit.imagePickerFromCamera();
                                Navigator.pop(context);
                              }, () {
                                cubit.imagePickerFromGallery();
                                Navigator.pop(context);
                              });
                            },
                            icon: const Icon(
                              Icons.upload,
                              size: 28,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    if (cubit.file != null)
                      const SizedBox(
                        height: 15,
                      ),
                    if (cubit.file != null)
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Image.file(
                          cubit.file!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                    if (state is InstgramLoadingSendPostsState)
                      const SizedBox(
                        height: 15,
                      ),
                    if (state is InstgramLoadingSendPostsState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    button(
                        color: Colors.blueAccent,
                        text: "Post",
                        function: () {
                          cubit.imageOfPost(
                              description: textEditingController.text,
                              datePublish: DateTimeFormat.format(DateTime.now(),
                                  format: 'D, M j, H:i'),
                              likes: []);
                        })
                  ],
                ),
              ),
            )
          : const Center(
              child: LinearProgressIndicator(),
            );
    }, listener: (context, state) {
      if (state is InstgramPostsState) {
        textEditingController.text = "";
        FocusScope.of(context).unfocus();
        if (textEditingController.text == "") {
          InstgramCubit.get(context).file = null;
        }
      }
    });
  }
}
