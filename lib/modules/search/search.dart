import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:muslm_instgram/components/components.dart';
import 'package:muslm_instgram/layout/bloc/cubit.dart';
import 'package:muslm_instgram/layout/bloc/states.dart';
import 'package:muslm_instgram/modules/addfollow/add_follow.dart';
import 'package:muslm_instgram/shared/local/const.dart';

class Search extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  Search({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstgramCubit, InstagramStates>(
        builder: (context, state) {
          var cubit = InstgramCubit.get(context);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                textFromField(
                    hint: "Search a User",
                    controller: textEditingController,
                    function: (v) {
                      return null;
                    },
                    onChange: (v) {
                      cubit.searchUser(
                          textEditingController: textEditingController.text);

                      return null;
                    }),
                const SizedBox(
                  height: 5,
                ),
                if (cubit.filter.isEmpty && textEditingController.text == "")
                  Expanded(
                      child: MasonryGridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    itemBuilder: (context, index) =>
                        cardOfMyPhoto(src: cubit.searchPost[index]),
                    itemCount: cubit.searchPost.length,
                  )),
                if (cubit.filter.isNotEmpty && textEditingController.text != "")
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => userSearch(
                            function: () {
                              cubit.followPerson(index: index);
                              if (cubit.followPersonUser != null) {
                                navigator(
                                    context: context,
                                    widget: AddFollow(
                                      index: index,
                                    ));
                                log("message");
                              }
                            },
                            url: cubit.filter[index].image,
                            text: cubit.filter[index].user),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 7,
                            ),
                        itemCount: cubit.filter.length),
                  )
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
