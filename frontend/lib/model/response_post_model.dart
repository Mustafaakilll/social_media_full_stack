import 'package:json_annotation/json_annotation.dart';

part 'response_post_model.g.dart';

@JsonSerializable()
class ResponsePostModel {
  ResponsePostModel(this.id, this.user, this.caption, this.createdAt, this.files, this.tags, this.likes,
      this.likesCount, this.comments, this.commentCount);

  factory ResponsePostModel.fromJson(Map<String, dynamic> json) => _$ResponsePostModelFromJson(json);

  @JsonKey(name: '_id')
  String id;
  String user;
  String caption;
  DateTime createdAt;
  List files;
  List? tags;
  List? likes;
  int? likesCount;
  List? comments;
  int? commentCount;
}
