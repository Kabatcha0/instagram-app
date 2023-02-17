import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/modules/edit_profile/edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
      builder: (context, state) {
        var cubit = InstgramCubit.get(context);
        return Scaffold(
          body: cubit.getData == null &&
                  cubit.getPost.isEmpty &&
                  cubit.getPersonalPost.isEmpty
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
                            backgroundImage: NetworkImage(
                              cubit.getData!.image,
                            ),
                          ),
                          addFollow(
                              number: cubit.getPostLength.length,
                              details: "Posts"),
                          addFollow(
                              number: cubit.getData!.followers.length,
                              details: "Followers"),
                          addFollow(
                              number: cubit.getData!.following.length,
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
                                  cubit.getData!.user,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  cubit.getData!.bio,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                button(
                                    checkColor: true,
                                    text: "Edit Profile",
                                    function: () {
                                      navigator(
                                          context: context,
                                          widget: EditProfile());
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
                      if (cubit.getPersonalPost.isNotEmpty)
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
                              src: cubit.getPersonalPost[index],
                            ),
                            itemCount: cubit.getPersonalPost.length,
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
