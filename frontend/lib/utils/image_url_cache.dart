import 'package:dio/dio.dart';

import 'base_repository.dart';

class ImageUrlCache extends Repository {
  ImageUrlCache._init();

  factory ImageUrlCache() => _instance;

  static final ImageUrlCache _instance = ImageUrlCache._init();

  final Map<String, dynamic> cacheUrl = {};

  Future<String> getUrl(String postId) async {
    String? url = cacheUrl[postId];

    if (url == null) {
      try {
        final response = await dio.get('http://10.242.17.230:3000/posts/$postId',
            options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
        url = response.data['data']['files'][0];
        cacheUrl[postId] = url;
      } catch (e) {
        throw Exception(e);
      }
    }
    return url!;
  }
}
