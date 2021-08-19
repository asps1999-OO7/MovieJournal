import 'package:movielisting/bloc/movie_bloc.dart';
import 'package:movielisting/db/database_provider.dart';
import 'package:movielisting/events/add_movie.dart';
import 'package:movielisting/events/update_movie.dart';
import 'package:movielisting/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:movielisting/model/movie.dart';

class MovieForm extends StatefulWidget {
  final Movie movie;
  final int movieIndex;

  MovieForm
({this.movie, this.movieIndex});

  @override
  State<StatefulWidget> createState() {
    return MovieFormState();
  }
}

class MovieFormState extends State<MovieForm> {
  String _name;
  String _desp;
  bool _isFav = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name',labelStyle: TextStyle(color: Colors.white)),
      maxLength: 50,
      style: TextStyle(fontSize: 28,color: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildDesp() {
    return TextFormField(
      initialValue: _desp,
      decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.white)),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 28, color: Colors.white),
      validator: (String value) {
        //int desp = int.tryParse(value);

        /*if (desp == null || desp <= 0) {
          return 'desp should be written';
        }*/

        return null;
      },
      onSaved: (String value) {
        _desp = value;
      },
    );
  }

  Widget _buildIsFav() {
    return SwitchListTile(
      title: Text("Favourite?", style: TextStyle(fontSize: 20,color: Colors.white)),
      value: _isFav,
      onChanged: (bool newValue) => setState(() {
        _isFav = newValue;
        
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _name = widget.movie.name;
      _desp = widget.movie.desp;
      _isFav = widget.movie.isFav;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/interstellar-movie-wallpaper-preview.jpg"),fit: BoxFit.cover,)),
      child: Scaffold(
        appBar: AppBar(title: Text("Tell me about the movie"),
        backgroundColor: Colors.indigo[200],),
        body: Container(
          //height: 100,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/Kylo-Ren-Star-Wars-Wallpaper-1080x1920.jpg"),fit: BoxFit.cover,)),
          child: Container(
            
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildName(),
                  _buildDesp(),
                  SizedBox(height: 16),
                  _buildIsFav(),
                  SizedBox(height: 20),
                  widget.movie == null
                      ? ElevatedButton(
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            Movie movie = Movie(
                              name: _name,
                              desp: _desp,
                              isFav: _isFav,
                            );

                            DatabaseProvider.db.insert(movie).then(
                                  (storedMovie) =>
                                      BlocProvider.of<MovieBloc>(context).add(
                                    AddMovie(storedMovie),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo[200],

                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  print("form");
                                  return;
                                }

                                _formKey.currentState.save();

                                Movie movie = Movie(
                                  name: _name,
                                  desp: _desp,
                                  isFav: _isFav,
                                );

                                DatabaseProvider.db.update(widget.movie).then(
                                      (storedMovie) =>
                                          BlocProvider.of<MovieBloc>(context).add(
                                        UpdateMovie(widget.movieIndex, movie),
                                      ),
                                    );

                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}