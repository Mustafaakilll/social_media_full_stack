import 'package:dio/dio.dart';

import '../utils/base_repository.dart';

class PostRepository extends Repository {
  Future<List> getPosts() async {
    try {
      final response = await dio.get('http://192.168.1.107:3000/users/feed',
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

  Future<void> addPost(String caption, String imageUrl) async {
    try {
      final tags = <String>[];
      final _listedCaption = caption.split(' ');
      final _cleanedCaption = [];
      for (final tag in _listedCaption) {
        if (tag.startsWith('#')) tags.add(tag);
      }
      for (final cap in _listedCaption) {
        if (!cap.startsWith('#')) _cleanedCaption.add(cap);
      }
      final response = await dio.put('http://192.168.1.107:3000/posts',
          data: {'tags': tags, 'caption': _cleanedCaption.join(' '), 'files': imageUrl},
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
      response.data['data']['isLiked'] = false;
      response.data['data']['isMine'] = true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> likePost(final postId) async {
    try {
      await dio.get('http://192.168.1.107:3000/posts/$postId/togglelike',
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
    } catch (e) {
      throw Exception(e);
    }
  }
}
