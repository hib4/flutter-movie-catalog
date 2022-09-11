import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../ui/detail/detail.dart';

class ItemMore extends StatelessWidget {
  final int id;
  final String poster;
  final String title;
  final num vote;
  final String language;
  final String release;

  const ItemMore(
      {Key? key,
      required this.id,
      required this.poster,
      required this.title,
      required this.vote,
      required this.language,
      required this.release})
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
        width: size.width,
        margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.145,
              margin: EdgeInsets.only(top: size.height * 0.05),
              decoration: BoxDecoration(
                color: Color(0XFF434051),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              height: size.height * 0.175,
              margin: EdgeInsets.only(left: 10, top: 8),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.25,
                    height: size.height * 0.175,
                    margin: EdgeInsets.only(right: 10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${poster}",
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black45],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.55,
                        child: Text(
                          "${title}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RatingBarIndicator(
                        rating: vote / 2,
                        direction: Axis.horizontal,
                        unratedColor: Colors.white.withOpacity(0.5),
                        itemSize: 16,
                        itemPadding: EdgeInsets.only(right: 4),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: Colors.amber,
                          );
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Bahasa: ${language}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Tanggal rilis: ${release}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
