class MovieFields {
  // database table
  static const popular = 'popular';
  static const nowPlaying = 'nowplaying';
  static const topRated = 'toprated';

  // database column
  static final String idMovie = 'idMovie';
  static final String id = 'id';
  static final String poster = 'posterPath';
  static final String backdrop = 'backdropPath';
  static final String title = 'title';
  static final String vote = 'voteAverage';
}

class MovieDatabaseModel {
  int? idMovie;
  int? id;
  String? posterPath;
  String? backdropPath;
  String? title;
  num? voteAverage;

  MovieDatabaseModel(
      {this.idMovie,
      this.id,
      this.posterPath,
      this.backdropPath,
      this.title,
      this.voteAverage});

  factory MovieDatabaseModel.fromMap(Map<String, dynamic> json) {
    return MovieDatabaseModel(
      idMovie: json['idMovie'],
      id: json['id'] as int?,
      posterPath: json['posterPath'],
      backdropPath: json['backdropPath'],
      title: json['title'],
      voteAverage: json['voteAverage'],
    );
  }

  Map<String, dynamic> toMap() => {
        MovieFields.idMovie: idMovie,
        MovieFields.id: id,
        MovieFields.poster: posterPath,
        MovieFields.backdrop: backdropPath,
        MovieFields.title: title,
        MovieFields.vote: voteAverage,
      };
}
