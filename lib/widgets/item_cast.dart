import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/config/responsive_config.dart';

class ItemCast extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String character;

  const ItemCast(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isLandscape(context) ? size.width * 0.11 : size.width * 0.22,
            height: isLandscape(context) ? size.height * 0.33 :size.height * 0.15,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl:
                  "https://image.tmdb.org/t/p/w500${imageUrl}",
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.grey.withOpacity(0.7),
                        Colors.transparent
                      ])),
                );
              },
            ),
          ),
          SizedBox(
            height: isLandscape(context) ? 5 : 0,
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            character,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
