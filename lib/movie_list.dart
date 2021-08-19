

import 'package:movielisting/db/database_provider.dart';
import 'package:movielisting/events/delete_movie.dart';
import 'package:movielisting/events/set_movies.dart';
import 'package:movielisting/movie_form.dart';
import 'package:movielisting/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/movie_bloc.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getMovies().then(
      (movieList) {
        BlocProvider.of<MovieBloc>(context).add(SetMovies(movieList));
      },
    );
  }

  showMovieDialog(BuildContext context, Movie movie, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(movie.name),
        content: Text("ID ${movie.id}"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MovieForm(movie: movie, movieIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          TextButton(
            onPressed: () => DatabaseProvider.db.delete(movie.id).then((_) {
              BlocProvider.of<MovieBloc>(context).add(
                DeleteMovie(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire movie list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie on your mind Puneet', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[200], fontSize: 24),),
        backgroundColor: Colors.black,
        leading: Image.asset(
          'assets/images/logo.PNG',height: 30,width: 40,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/interstellar-movie-wallpaper-preview.jpg"),fit: BoxFit.cover,)),
        padding: EdgeInsets.all(8),
        //color: Colors.black,
        child: BlocConsumer<MovieBloc, List<Movie>>(
          builder: (context, movieList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("movieList: $movieList");

                Movie movie = movieList[index];
                return Card(
                  child: ListTile(
                    tileColor: Colors.red[200],
                    contentPadding: EdgeInsets.all(16),
                    title: Text(movie.name, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Description: ${movie.desp}\nFavourite: ${movie.isFav}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showMovieDialog(context, movie, index),
                  ),
                );
              },
              itemCount: movieList.length,
            );
          },
          listener: (BuildContext context, movieList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MovieForm()),
        ),
      ),
    );
  }
}