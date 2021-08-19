import 'package:movielisting/model/movie.dart';

import 'movie_event.dart';

class SetMovies extends MovieEvent {
  List<Movie> movieList;

  SetMovies(List<Movie> movies) {
    movieList = movies;
  }
}