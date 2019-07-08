import 'package:json_annotation/json_annotation.dart';
part 'databits.g.dart';

@JsonSerializable()

class DataBits {
  final int id;
  final String author;
  final String created_at;
  final String description;
  final double thickness;
  final int nr_layers;
  final List<Comment> comments;

  DataBits({this.id, this.author, this.created_at,this.description,this.thickness,this.nr_layers,this.comments,});

  factory DataBits.fromJson(Map<String, dynamic> json) => _$DataBitsFromJson(json);

  Map<String, dynamic> toJson() => _$DataBitsToJson(this);
}

@JsonSerializable()

class Comment {
  final int commentId;
  final String commentAuthor;
  final String commentCreated_at;
  final String commentDescription;

  Comment({this.commentId,this.commentAuthor, this.commentCreated_at, this.commentDescription});

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
