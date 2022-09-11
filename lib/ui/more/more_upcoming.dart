import 'package:flutter/material.dart';
import 'package:tmdb/models/now_playing_model.dart';
import '../../services/api_service.dart';
import '../../widgets/item_more.dart';

class MoreUpComing extends StatefulWidget {
  const MoreUpComing({Key? key}) : super(key: key);

  @override
  State<MoreUpComing> createState() => _MoreUpComingState();
}

class _MoreUpComingState extends State<MoreUpComing> {
  NowPlayingModel? _model;
  bool _isLoaded = false;
  bool _hasMore = true;
  int _currentPage = 1;
  List<Results> _results = [];

  final _controller = ScrollController();

  Future<void> _getUpComing() async {
    _model = await ApiService().getNowPlaying(_currentPage);

    setState(() {

      if (_currentPage > 499) {
        _hasMore = false;
      } else {
        _results.addAll(_model!.results!);
        _currentPage++;
      }

      print("current page : " + _currentPage.toString());
      _isLoaded = true;
    });
  }

  void controller() {
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _getUpComing();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUpComing();
    controller();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sedang Tayang",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoaded
          ? ListView.builder(
        padding: EdgeInsets.only(bottom: 20),
        controller: _controller,
        itemCount: _results.length + 1,
        itemBuilder: (context, index) {
          if (index < _results.length) {
            return ItemMore(
              id: _results[index].id!,
              poster: _results[index].posterPath!,
              title: _results[index].title!,
              vote: _results[index].voteAverage!,
              language: _results[index].originalLanguage!,
              release: _results[index].releaseDate!,
            );
          } else {
            return Visibility(
              visible: _hasMore,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
