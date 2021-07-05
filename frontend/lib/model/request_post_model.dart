import 'package:json_annotation/json_annotation.dart';

part 'request_post_model.g.dart';

@JsonSerializable()
class RequestPostModel {
  RequestPostModel({required this.caption, required this.files, required this.tags});

  final String caption;
  final List files;
  final List tags;

  Map<String, dynamic> toJson(instance) => _$RequestPostModelToJson(this);
}
