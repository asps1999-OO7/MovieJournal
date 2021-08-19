import 'package:movielisting/model/movie.dart';

import 'movie_event.dart';

class UpdateMovie extends MovieEvent {
  Movie newMovie;
  int movieIndex;

  UpdateMovie(int index, Movie movie) {
    newMovie = movie;
    movieIndex = index;
  }
}