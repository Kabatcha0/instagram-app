import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muslm_instgram/modules/comments/comments.dart';

Widget textFromField(
    {required String hint,
    required TextEditingController controller,
    required String? Function(String?) function,
    String? Function(String?)? onChange,
    Function(String)? onSubmit,
    int maxLines = 1,
    double? width,
    TextInputType type = TextInputType.emailAddress,
    bool show = false}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: Colors.grey[800]),
    child: TextFormField(
      onFieldSubmitted: onSubmit,
      maxLines: maxLines,
      keyboardType: type,
      controller: controller,
      validator: function,
      obscureText: show,
      onChanged: onChange,
      cursorColor: Colors.grey[500],
      decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.bold)),
      style: TextStyle(color: Colors.grey[500], fontSize: 16),
    ),
  );
}

Widget button(
    {Color? color,
    required String text,
    required Function() function,
    bool border = false,
    bool checkColor = false}) {
  return Container(
    width: double.infinity,
    height: 45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: checkColor ? null : color,
        border: border ? Border.all(color: Colors.white) : null),
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

void navigator({
  required BuildContext context,
  required Widget widget,
}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigatorPushReplacement(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

Widget circleAvatar(
    {required double raduis,
    required String image,
    bool file = false,
    File? photo}) {
  return CircleAvatar(
    backgroundImage:
        file ? FileImage(photo!) : NetworkImage(image) as ImageProvider,
    radius: raduis,
  );
}

show(BuildContext context, Function() functionCamera,
    Function() functionGallery) {
  return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              const SizedBox(
                height: 15,
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: functionCamera,
                child: const Text(
                  "Take a photo",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: functionGallery,
                child: const Text(
                  "From Gallery",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ));
}

Widget cardOfPosts(
    {required BuildContext context,
    required TextEditingController textEditingController,
    required Function() functionOfCamera,
    required Function() functionOfGallery,
    required Function() functionOfDelete,
    required Function() getLikes,
    required String image,
    required int index,
    String? imagePost,
    required bool likeChange,
    required String username,
    required String date,
    Function(String)? onSubmit,
    required int likes,
    String? text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            )),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              onPressed: functionOfDelete,
                              child: const SizedBox(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // SimpleDialogOption(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   onPressed: functionGallery,
                            //   child: const Text(
                            //     "From Gallery",
                            //     style: TextStyle(fontSize: 20),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            SimpleDialogOption(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ));
              },
              child: const Icon(
                Icons.more_vert,
                size: 28,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      if (imagePost != "" && imagePost != null)
        SizedBox(
          width: double.infinity,
          height: 300,
          child: Image.network(
            imagePost,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      const SizedBox(
        height: 5,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            InkWell(
                onTap: getLikes,
                child: likeChange
                    ? const Icon(
                        Icons.favorite,
                        size: 32,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                        size: 32,
                      )),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                navigator(context: context, widget: Comments(i: index));
              },
              child: const Icon(
                Icons.comment,
                size: 32,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.send,
                size: 32,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.bookmark_outline,
                size: 32,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "$likes likes",
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                  TextSpan(
                      text: "$username ",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  if (text != null && text != "") TextSpan(text: text)
                ])),
          )),
      const SizedBox(
        height: 8,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          child: InkWell(
            onTap: () {
              navigator(
                  context: context,
                  widget: Comments(
                    i: index,
                  ));
            },
            child: const Text(
              "View all Comments",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          child: InkWell(
            onTap: () {},
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commments(
    {String? comment,
    String? imageComment,
    required String date,
    required String user,
    required String image}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(image),
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                    TextSpan(
                        text: "$user ",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    if (comment != null && comment != "")
                      TextSpan(text: comment)
                  ])),
            ),
            if (imageComment != "" && imageComment != null)
              const SizedBox(
                height: 10,
              ),
            if (imageComment != "" && imageComment != null)
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 150,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Image.network(
                  imageComment,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                onTap: () {},
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      InkWell(
        onTap: () {},
        child: const Icon(
          Icons.favorite_outline_outlined,
          size: 20,
          color: Colors.white,
        ),
      )
    ],
  );
}

Widget userSearch({
  required Function() function,
  required String url,
  required String text,
}) {
  return ListTile(
    onTap: function,
    leading: CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(url),
    ),
    title: Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}

Widget addFollow({
  required int number,
  required String details,
}) {
  return Column(
    children: [
      Text(
        "$number",
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        details,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget cardOfMyPhoto({required String src}) {
  return SizedBox(
    child: Image.network(
      src,
      fit: BoxFit.cover,
    ),
  );
}
