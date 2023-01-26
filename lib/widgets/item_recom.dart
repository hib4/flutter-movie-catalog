import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/responsive_config.dart';
import '../ui/detail/detail.dart';

class ItemRecommendation extends StatelessWidget {
  final int id;
  final String title;
  final String poster;
  final double vote;

  const ItemRecommendation(
      {Key? key,
      required this.id,
      required this.title,
      required this.poster,
      required this.vote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detail(id: id),
          ),
        );
      },
      child: Container(
        width: isLandscape(context) ? size.width * 0.155 : size.width * 0.3,
        margin: EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.3,
              height: isLandscape(context) ? size.height * 0.45 : size.height * 0.22,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/w500${poster}",
                fit: BoxFit.fill,
                placeholder: (context, url) {
                  return Container(
                    width: size.width * 0.28,
                    height: size.height * 0.2,
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
              height: size.height * 0.01,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            RatingBarIndicator(
              rating: vote / 2,
              direction: Axis.horizontal,
              unratedColor: Colors.white.withOpacity(0.5),
              itemSize: 14,
              itemPadding: EdgeInsets.only(right: 4),
              itemCount: 5,
              itemBuilder: (context, index) {
                return FaIcon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
