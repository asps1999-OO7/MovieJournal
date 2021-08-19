import 'package:movielisting/model/movie.dart';

import 'movie_event.dart';

class AddMovie extends MovieEvent {
  Movie newMovie;

  AddMovie(Movie movie) {
    newMovie = movie;
  }
}