import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/modules/chat/chat.dart';

class Home extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  Home({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        PageController pageController = PageController(initialPage: 1);
        var cubit = InstgramCubit.get(context);
        return cubit.getPost.isEmpty &&
                cubit.getComment.isEmpty &&
                cubit.getLikes.isEmpty &&
                cubit.length.isEmpty
            ? Container()
            : PageView(
                controller: pageController,
                children: [
                  const Chat(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return cardOfPosts(
                              functionOfDelete: () {
                                cubit.deleteImagePost(
                                    postId: cubit.getPost[index].postId,
                                    image: cubit.getPost[index].postUrl);
                                Navigator.pop(context);
                              },
                              index: index,
                              getLikes: () {
                                cubit.likeThePosts(
                                    postId: cubit.getPost[index].postId,
                                    likes: cubit.getPost[index].likes);
                              },
                              likeChange:
                                  cubit.getLikes[cubit.getPost[index].postId]!,
                              likes: cubit.getPost[index].likes.length,
                              context: context,
                              date: cubit.getPost[index].datePublish,
                              username: cubit.getPost[index].user,
                              text: cubit.getPost[index].description,
                              textEditingController: textEditingController,
                              functionOfCamera: () {
                                cubit.imagePickerFromCamera();
                                Navigator.pop(context);
                              },
                              functionOfGallery: () {
                                cubit.imagePickerFromGallery();
                                Navigator.pop(context);
                              },
                              image: cubit.getPost[index].image,
                              imagePost: cubit.getPost[index].postUrl);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 40,
                            ),
                        itemCount: cubit.getPost.length),
                  )
                ],
              );
      },
      listener: (context, state) {},
    );
  }
}
