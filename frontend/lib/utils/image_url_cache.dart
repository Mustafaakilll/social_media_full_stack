import 'package:dio/dio.dart';

import 'storage_helper.dart';

class ImageUrlCache {
  ImageUrlCache._init();

  factory ImageUrlCache() => _instance;

  static final ImageUrlCache _instance = ImageUrlCache._init();

  final Map<String, dynamic> cacheUrl = {};
  final Dio _dio = Dio();
  Future<Object> get _token async => await StorageHelper().getData('token', 'auth');

  Future<String> getUrl(String postId) async {
    String? url = cacheUrl[postId];

    if (url == null) {
      try {
        final response = await _dio.get('http://192.168.1.110:3000/posts/$postId',
            options: Options(headers: {'Authorization': 'Bearer ${await _token}'}));
        url = response.data['data']['files'][0];
        cacheUrl[postId] = url;
      } catch (e) {
        throw Exception(e);
      }
    }
    return url!;
  }
}
