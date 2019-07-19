
class TubesList{
  final List<Tubes> tubesList;

  TubesList({this.tubesList});
  factory TubesList.fromJson(List<dynamic> json) {
    List<Tubes> tubesList = new List<Tubes>();
    tubesList = json.map((i)=>Tubes.fromJson(i)).toList();
    return new TubesList(tubesList: tubesList);
  }
}

class Tubes {
  final int id;
  final int nr_layers;
  final double thickness;
  final String author;
  final String description;
  final String created_at;

  Tubes({this.id, this.author, this.created_at,this.description,this.thickness,this.nr_layers,});

  factory Tubes.fromJson(Map<String, dynamic> json) {
   return Tubes(
       id: json['id'] as int,
       author: json['author'] as String,
       created_at: json['created_at'] as String,
       description: json['description'] as String,
       thickness: (json['thickness'] as num)?.toDouble(),
       nr_layers: json['nr_layers'] as int, );
}


  Map<String, dynamic> toJson()=> <String, dynamic>{
       'id': this.id,
       'author': this.author,
       'created_at': this.created_at,
       'description': this.description,
       'thickness': this.thickness,
       'nr_layers': this.nr_layers,
     };

}
