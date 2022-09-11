import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemVideo extends StatelessWidget {
  final String ytKey;

  const ItemVideo({Key? key, required this.ytKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () async {
        String url = "https://www.youtube.com/watch?v=${ytKey}";

        if (await launch(url)) {
          await canLaunch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          Container(
            width: size.width * 0.45,
            margin: EdgeInsets.only(right: 15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              "https://img.youtube.com/vi/${ytKey}/0.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Image.asset(
            "assets/images/play.png",
            width: 40,
          ),
        ],
      ),
    );
  }
}
