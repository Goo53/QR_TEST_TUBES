// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'databits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataBits _$DataBitsFromJson(Map<String, dynamic> json) {
  return DataBits(
      id: json['id'] as int,
      author: json['author'] as String,
      created_at: json['created_at'] as String,
      description: json['description'] as String,
      thickness: (json['thickness'] as num)?.toDouble(),
      nr_layers: json['nr_layers'] as int,
      comments: (json['comments'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataBitsToJson(DataBits instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'created_at': instance.created_at,
      'description': instance.description,
      'thickness': instance.thickness,
      'nr_layers': instance.nr_layers,
      'comments': instance.comments
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      commentId: json['commentId'] as int,
      commentAuthor: json['commentAuthor'] as String,
      commentCreated_at: json['commentCreated_at'] as String,
      commentDescription: json['commentDescription'] as String);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'commentAuthor': instance.commentAuthor,
      'commentCreated_at': instance.commentCreated_at,
      'commentDescription': instance.commentDescription
    };
