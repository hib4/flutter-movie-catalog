import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/database/init/database.dart';
import 'package:tmdb/database/model/database_model.dart';
import 'package:tmdb/models/movie_model.dart';
import 'package:tmdb/services/data.dart';
import 'dart:io' show Platform;
import 'package:tmdb/ui/detail/detail.dart';
import 'package:tmdb/ui/more/more_trending.dart';
import 'package:tmdb/ui/more/more_upcoming.dart';
import 'package:tmdb/services/api_service.dart';
import 'package:tmdb/ui/shimmer/home_shimmer.dart';
import 'package:tmdb/widgets/item_movie.dart';
import 'package:tmdb/widgets/theme.dart';

import '../../config/responsive_config.dart';
import '../detail/detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MovieModel? _npModel;
  MovieModel? _tpModel;
  MovieModel? _popularModel;

  List _npResult = [];
  List _tpResult = [];
  List _popularResult = [];

  DatabaseHelper _db = DatabaseHelper.instance;
  bool _isLoaded = false;
  int _currentPage = 0;

  CarouselController _carouselController = CarouselController();

  Future getPopular() async {
    _popularModel = await ApiService().getPopular(1);
    _popularResult = _popularModel!.results!;

    await _db.deleteTable(MovieFields.popular);

    for (int i = 0; i < _popularResult.length; i++) {
      final data = _popularResult[i];
      var result = MovieDatabaseModel(
        id: data.id,
        posterPath: data.posterPath,
        backdropPath: data.backdropPath,
        title: data.title,
        voteAverage: data.voteAverage,
      );
      await _db.create(MovieFields.popular, result);
    }
  }

  Future getNowPlaying() async {
    _npModel = await ApiService().getNowPlaying(1);
    _npResult = _npModel!.results!;

    await _db.deleteTable(MovieFields.nowPlaying);

    for (int i = 0; i < _npResult.length; i++) {
      final data = _npResult[i];
      var result = MovieDatabaseModel(
        id: data.id,
        posterPath: data.posterPath,
        backdropPath: data.backdropPath,
        title: data.title,
        voteAverage: data.voteAverage,
      );
      await _db.create(MovieFields.nowPlaying, result);
    }
  }

  Future getTopRated() async {
    _tpModel = await ApiService().getTopRated(1);
    _tpResult = _tpModel!.results!;

    await _db.deleteTable(MovieFields.topRated);

    for (int i = 0; i < 5; i++) {
      final data = _tpResult[i];
      var result = MovieDatabaseModel(
        id: data.id,
        posterPath: data.posterPath,
        backdropPath: data.backdropPath,
        title: data.title,
        voteAverage: data.voteAverage,
      );
      await _db.create(MovieFields.topRated, result);
    }
  }

  Future<void> getApi() async {
    var connectivity = await (Connectivity().checkConnectivity());

    if (connectivity == ConnectivityResult.none) {
      print("connectivity none");

      _npResult = await _db.read(MovieFields.nowPlaying);
      _tpResult = await _db.read(MovieFields.topRated);
      _popularResult = await _db.read(MovieFields.popular);

      print(_popularResult.length);
    } else {
      print("connectivity ready");
      Provider.of<Data>(context, listen: false).fetchdata(context);
    }

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: _isLoaded
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: padding.top + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, Fawwaz",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Pilih film favoritmu!",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage("assets/images/daniel.jpg"),
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
                        var result = provider.tpResult[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(id: result.id!),
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
                                      "https://image.tmdb.org/t/p/w500${result.backdropPath}",
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
                                    result.title!,
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
                          viewportFraction: isLandscape(context) ? 0.75 : 0.85,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          height: isLandscape(context) ? size.height * 0.7 : size.height * 0.25,
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
                                  ),
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
                        itemCount: _popularResult.length,
                        itemBuilder: (context, index) {
                          var result = _popularResult[index];
                          return ItemMovie(
                              id: provider.popularResult[index],
                              image: result.posterPath,
                              title: result.title,
                              rating: result.voteAverage);
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
                                  ),
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
                        itemCount: _npResult.length,
                        itemBuilder: (context, index) {
                          var result = provider.npResult[index];
                          return ItemMovie(
                              id: result.id,
                              image: result.posterPath,
                              title: result.title,
                              rating: result.voteAverage);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : HomeShimmer(),
    );
  }
}
