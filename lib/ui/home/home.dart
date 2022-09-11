import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' show Platform;
import 'package:tmdb/models/now_playing_model.dart';
import 'package:tmdb/models/popular_model.dart';
import 'package:tmdb/models/up_coming_model.dart';
import 'package:tmdb/ui/detail/detail.dart';
import 'package:tmdb/ui/more/more_trending.dart';
import 'package:tmdb/ui/more/more_upcoming.dart';
import 'package:tmdb/services/api_service.dart';
import 'package:tmdb/widgets/item_movie.dart';
import 'package:tmdb/widgets/theme.dart';

import '../detail/detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NowPlayingModel? _npModel;
  UpComingModel? _ucModel;
  PopularModel? _popularModel;
  bool _isLoaded = false;
  int _currentPage = 0;

  CarouselController _carouselController = CarouselController();

  Future<void> getNowPlaying() async {
    _ucModel = await ApiService().getUpComing(1);
    _npModel = await ApiService().getNowPlaying(1);
    _popularModel = await ApiService().getPopular(1);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNowPlaying();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: _isLoaded
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: padding.top + 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage("assets/images/daniel.jpg"),
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.locationDot,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Semarang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          FaIcon(
                            FontAwesomeIcons.bell,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Paling Popular",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    CarouselSlider.builder(
                      itemCount: 5,
                      carouselController: _carouselController,
                      itemBuilder: (context, index, pageViewIndex) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Detail(id: _ucModel!.results![index].id!),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/w500${_ucModel!.results![index].backdropPath}",
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  bottom: 20,
                                  child: Text(
                                    _ucModel!.results![index].title!,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          pauseAutoPlayOnTouch: true,
                          initialPage: 0,
                          viewportFraction: 0.85,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          height: size.height * 0.25,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentPage = index;
                            });
                          }),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          5,
                          (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              width: (index == _currentPage) ? 30 : 12,
                              height: 10,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (index == _currentPage)
                                    ? Color(0XFF4D438A)
                                    : Color(0XFF2A2740),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Trending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoreTrending(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 14,
                                      height: 1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 14,
                                  color: secondaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 20),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _npModel?.results?.length,
                        itemBuilder: (context, index) {
                          return ItemMovie(
                              id: _popularModel!.results![index].id!,
                              image: _popularModel!.results![index].posterPath!,
                              title: _popularModel!.results![index].title!,
                              rating:
                                  _popularModel!.results![index].voteAverage!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Sedang Tayang",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoreUpComing(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Lihat Semua",
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 14,
                                      height: 1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 14,
                                  color: secondaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 20),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _npModel?.results?.length,
                        itemBuilder: (context, index) {
                          return ItemMovie(
                              id: _npModel!.results![index].id!,
                              image: _npModel!.results![index].posterPath!,
                              title: _npModel!.results![index].title!,
                              rating: _npModel!.results![index].voteAverage!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
