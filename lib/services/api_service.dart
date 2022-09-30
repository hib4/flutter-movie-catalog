import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tmdb/models/detail_model.dart';
import 'package:tmdb/models/movie_model.dart';
import 'package:tmdb/models/recommendation_model.dart';

class ApiService {
  final baseUrl = "https://api.themoviedb.org/3/";
  final apiKey = "?api_key=6336e4208132f6206aa0b05d04b1fda7";

  Future getNowPlaying(int page) async {
    final endPoint = "movie/now_playing";
    String query = "&page=$page";
    String url = "$baseUrl$endPoint$apiKey$query";

    try {
      final response = await http.get(Uri.parse(url));

      print("get now playing : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        MovieModel? model = MovieModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getTopRated(int page) async {
    final endPoint = "movie/top_rated";
    String query = "&page=$page";
    String url = "$baseUrl$endPoint$apiKey$query";

    try {
      final response = await http.get(Uri.parse(url));

      print("get upcoming : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        MovieModel? model = MovieModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getPopular(int page) async {
    final endPoint = "movie/popular";
    String query = "&page=$page";
    String url = "$baseUrl$endPoint$apiKey$query";

    try {
      final response = await http.get(Uri.parse(url));

      print("get popular : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        MovieModel? model = MovieModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getDetail(int id) async {
    final endPoint = "movie/$id";
    final query = "&language=en-US&append_to_response=videos,credits";
    String url = "$baseUrl$endPoint$apiKey$query";

    try {
      final response = await http.get(Uri.parse(url));

      print("get detail : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        DetailMovieModel? model =
            DetailMovieModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getRecommendation(int id) async {
    final endPoint = "movie/$id/recommendations";
    String url = "$baseUrl$endPoint$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      print("get recommendation : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        RecommendationModel model =
            RecommendationModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
