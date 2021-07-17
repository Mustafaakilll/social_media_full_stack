// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsePostModel _$ResponsePostModelFromJson(Map<String, dynamic> json) {
  return ResponsePostModel(
    json['_id'] as String,
    json['user'] as String,
    json['caption'] as String,
    DateTime.parse(json['createdAt'] as String),
    json['files'] as List<dynamic>,
    json['tags'] as List<dynamic>?,
    json['likes'] as List<dynamic>?,
    json['likesCount'] as int?,
    json['comments'] as List<dynamic>?,
    json['commentCount'] as int?,
  );
}

Map<String, dynamic> _$ResponsePostModelToJson(ResponsePostModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'caption': instance.caption,
      'createdAt': instance.createdAt.toIso8601String(),
      'files': instance.files,
      'tags': instance.tags,
      'likes': instance.likes,
      'likesCount': instance.likesCount,
      'comments': instance.comments,
      'commentCount': instance.commentCount,
    };
