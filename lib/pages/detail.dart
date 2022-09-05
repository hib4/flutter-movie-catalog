import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmdb/models/detail.dart';
import 'package:tmdb/models/recommendation.dart';
import 'package:tmdb/services/api_service.dart';
import 'package:tmdb/widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  final int id;

  const Detail({Key? key, required this.id}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  DetailMovieModel? detailModel;
  RecommendationModel? recomModel;
  bool isLoaded = false;

  Future<void> getDetail() async {
    detailModel = await ApiService().getDetail(widget.id);
    recomModel = await ApiService().getRecommendation(widget.id);
    setState(() {
      isLoaded = true;
    });
  }

  Future _openUrl(String url) async {
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days} hari');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours} jam');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes} menit');
    }

    return tokens.join(' ');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoaded
          ? SingleChildScrollView(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      String url =
                          "https://www.youtube.com/watch?v=${detailModel!.videos!.results![0].key}";

                      _openUrl(url);
                    },
                    child: Container(
                      height: size.height * 0.3,
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                "https://image.tmdb.org/t/p/w500${detailModel!.backdropPath}",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.0),
                                  end: Alignment(0.0, 1.0),
                                  colors: [
                                    Colors.black45,
                                    backgroundColor,
                                  ]),
                            ),
                          ),
                          Image.asset(
                            "assets/images/play.png",
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: size.width * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: size.width * 0.35,
                                height: size.height * 0.25,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/w500${detailModel!.posterPath}",
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return Container(
                                      width: size.width * 0.18,
                                      height: size.height * 0.13,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.grey.withOpacity(0.7),
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.5,
                                    child: Text(
                                      detailModel!.title!,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: size.width * 0.5,
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          children: [
                                            Text(
                                              "Genre",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              detailModel!.genres![0].name!,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Text(
                                              "Durasi",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              formatDuration(
                                                Duration(
                                                    minutes:
                                                        detailModel!.runtime!),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Text(
                                              "Sutradara",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "Taika Watiti",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Text(
                                              "Tanggal Rilis",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              detailModel!.releaseDate!,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.25,
                                height: size.height * 0.07,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RatingBarIndicator(
                                      rating: detailModel!.voteAverage! / 2,
                                      direction: Axis.horizontal,
                                      unratedColor:
                                          Colors.white.withOpacity(0.5),
                                      itemSize: 14,
                                      itemPadding: EdgeInsets.only(right: 1),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return FaIcon(
                                          FontAwesomeIcons.solidStar,
                                          color: Colors.amber,
                                        );
                                      },
                                    ),
                                    Text(
                                      "${detailModel!.voteAverage!.toString().substring(0, 3)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width * 0.25,
                                height: size.height * 0.07,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${detailModel!.status}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width * 0.25,
                                height: size.height * 0.07,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "P-G",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "16+",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                "Ringkasan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text(
                                detailModel!.overview!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Pemeran",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: size.height * 0.21,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount: detailModel?.credits?.cast?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: size.width * 0.18,
                                margin: EdgeInsets.only(right: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width * 0.18,
                                      height: size.height * 0.13,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/w500${detailModel!.credits!.cast![index].profilePath}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Container(
                                            width: size.width * 0.18,
                                            height: size.height * 0.13,
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
                                    Text(
                                      detailModel!.credits!.cast![index].name!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      detailModel!
                                          .credits!.cast![index].character!,
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
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Video",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.14,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount: detailModel?.videos?.results?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  String url =
                                      "https://www.youtube.com/watch?v=${detailModel!.videos!.results![index].key}";

                                  _openUrl(url);
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
                                        "https://img.youtube.com/vi/${detailModel!.videos!.results![index].key}/0.jpg",
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
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Rekomendasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.28,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount: recomModel?.results?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Detail(
                                          id: recomModel!.results![index].id!),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: size.width * 0.3,
                                  margin: EdgeInsets.only(right: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * 0.3,
                                        height: size.height * 0.22,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/w500${recomModel!.results![index].posterPath}",
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) {
                                            return Container(
                                              width: size.width * 0.28,
                                              height: size.height * 0.2,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                    Colors.grey
                                                        .withOpacity(0.7),
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
                                        recomModel!.results![index].title!,
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
                                        rating: recomModel!
                                                .results![index].voteAverage! /
                                            2,
                                        direction: Axis.horizontal,
                                        unratedColor:
                                            Colors.white.withOpacity(0.5),
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
