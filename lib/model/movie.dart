import 'package:movielisting/db/database_provider.dart';

class Movie{
  int id;
  String name;
  String desp;
  bool isFav;

  Movie({this.id, this.name, this.desp, this.isFav});

  Map<String,dynamic>toMap(){
  var map=<String, dynamic>{
    DatabaseProvider.COLUMN_NAME: name,
    DatabaseProvider.COLUMN_DESP: desp,
    DatabaseProvider.COLUMN_FAV: isFav ? 1 : 0,
  };
  
  if(id!=null){
    map[DatabaseProvider.COLUMN_ID]=id;
  }
  return map;
}

  Movie.fromMap(Map<String,dynamic> map){
    id=map[DatabaseProvider.COLUMN_ID];
    name=map[DatabaseProvider.COLUMN_NAME];
    desp=map[DatabaseProvider.COLUMN_DESP];
    isFav=map[DatabaseProvider.COLUMN_FAV]==1;
    
  }
}

