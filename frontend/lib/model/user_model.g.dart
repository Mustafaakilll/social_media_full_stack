// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['_id'] as String?,
    username: json['username'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String,
    password: json['password'] as String,
    followers: json['followers'] as List<dynamic>?,
    followersCount: json['followersCount'] as int,
    following: json['following'] as List<dynamic>?,
    followingCount: json['followingCount'] as int,
    posts: json['posts'] as List<dynamic>?,
    postCount: json['postCount'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'followers': instance.followers,
      'followersCount': instance.followersCount,
      'following': instance.following,
      'followingCount': instance.followingCount,
      'posts': instance.posts,
      'postCount': instance.postCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
