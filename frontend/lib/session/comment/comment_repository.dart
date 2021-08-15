import 'dart:developer';

import 'package:dio/dio.dart';

import '../../utils/base_repository.dart';

class CommentRepository extends Repository {
  Future addComment(String postId, String comment) async {
    try {
      final response = await dio.post('https://socialmedia.loca.lt/posts/$postId/comments',
          data: {'text': comment}, options: Options(headers: {'Authorization': 'Bearer ${await token}'}));

      log(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
