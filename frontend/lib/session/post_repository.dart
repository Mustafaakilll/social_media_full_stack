import 'package:dio/dio.dart';

import '../utils/base_repository.dart';

class PostRepository extends Repository {
  Future<List> getPosts() async {
    try {
      final response = await dio.get('https://socialmedia.loca.lt/users/feed',
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
      return response.data['data'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> uploadFileToCloud(String file) async {
    try {
      final _rawData = {'upload_preset': 'ml_default', 'file': await MultipartFile.fromFile(file)};
      final _formData = FormData.fromMap(_rawData);
      final _response = await dio.post('https://api.cloudinary.com/v1_1/demosocialmedia/image/upload', data: _formData);
      return _response.data['secure_url'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addPost(String caption, String imageUrl, List<String> tags) async {
    try {
      final response = await dio.put('https://socialmedia.loca.lt/posts',
          data: {'tags': tags, 'caption': caption, 'files': imageUrl},
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
      response.data['data']['isLiked'] = false;
      response.data['data']['isMine'] = true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
