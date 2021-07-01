import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.password,
    this.followers,
    required this.followersCount,
    this.following,
    required this.followingCount,
    this.posts,
    required this.postCount,
    required this.createdAt,
  });

  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String email;
  final String password;
  final String avatar;
  final List? followers;
  final int followersCount;
  final List? following;
  final int followingCount;
  final List? posts;
  final int postCount;
  final DateTime createdAt;

  // ignore: sort_constructors_first
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson(instance) => _$UserModelToJson(this);
}
