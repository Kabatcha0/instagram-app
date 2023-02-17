import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';

class AddFollow extends StatelessWidget {
  int index;
  AddFollow({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        var cubit = InstgramCubit.get(context);
        return Scaffold(
          appBar: cubit.followPersonUser == null
              ? AppBar()
              : AppBar(
                  title: Text(
                    cubit.followPersonUser!.user,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
          body: cubit.followPersonUser == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(cubit.followPersonUser!.image),
                          ),
                          addFollow(
                              number: cubit.followPersonUser!.posts,
                              details: "Posts"),
                          addFollow(
                              number: cubit.followPersonUser!.followers.length,
                              details: "Followers"),
                          addFollow(
                              number: cubit.followPersonUser!.following.length,
                              details: "Following"),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cubit.followPersonUser!.user,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  cubit.followPersonUser!.bio,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (cubit.changeFollow == false)
                                  button(
                                      color: Colors.blueAccent,
                                      text: "Follow",
                                      function: () {
                                        cubit.following();
                                      }),
                                if (cubit.changeFollow == true)
                                  button(
                                      checkColor: true,
                                      text: "Done",
                                      function: () {
                                        cubit.following();
                                      },
                                      border: true)
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.5,
                            childAspectRatio: 1.05,
                            mainAxisSpacing: 3.5,
                          ),
                          itemBuilder: (context, index) => cardOfMyPhoto(
                            src: cubit.images[index],
                          ),
                          itemCount: cubit.images.length,
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
      listener: (context, state) {},
    );
  }
}
