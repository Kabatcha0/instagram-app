import 'dart:developer';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';

class Comments extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  int i;

  Comments({super.key, required this.i});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        var cubit = InstgramCubit.get(context);
        if (cubit.showComments == true) {
          cubit.getComments(postId: cubit.getPost[i].postId);
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Comments",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: cubit.getComment.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                      itemBuilder: (context, index) => commments(
                          imageComment: cubit.imageComment,
                          user: cubit.getData!.user,
                          comment: cubit.getComment[index].comment,
                          image: cubit.getData!.image,
                          date: cubit.getComment[index].datePublish),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: cubit.getComment.length),
                ),
          bottomNavigationBar: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 5, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      show(context, () {
                        cubit.imagePickerFromCamera();
                      }, () {
                        cubit.imagePickerFromGallery();
                      });
                    },
                    icon: const Icon(
                      Icons.upload,
                      size: 23,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: textFromField(
                        hint: "Write a Comment",
                        controller: textEditingController,
                        function: (v) {
                          return null;
                        })),
                TextButton(
                    onPressed: () {
                      cubit.uploadImageInComment(
                          postId: cubit.getPost[i].postId,
                          user: cubit.getData!.user,
                          datePublish: DateTimeFormat.format(DateTime.now(),
                              format: 'D, M j, H:i'),
                          comment: textEditingController.text,
                          likes: []);
                    },
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 17,
                      ),
                    ))
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is InstgramGetCommentsState) {
          textEditingController.text = "";
          InstgramCubit.get(context).file = null;
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
