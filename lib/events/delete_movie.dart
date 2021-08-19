import 'movie_event.dart';

class DeleteMovie extends MovieEvent {
  int movieIndex;

  DeleteMovie(int index) {
    movieIndex = index;
  }
}