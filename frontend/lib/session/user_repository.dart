import 'package:dio/dio.dart';

import '../utils/base_repository.dart';

class UserRepository extends Repository {
  Future<Map> getUserByUsername(String username) async {
    try {
      final result = await dio.get('http://192.168.1.107:3000/users/$username',
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
      return result.data['data'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> follow(String userId) async {
    try {
      await dio.get('http://192.168.1.107:3000/users/$userId/follow',
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> unfollow(String userId) async {
    try {
      await dio.get('http://192.168.1.107:3000/users/$userId/unfollow',
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
    } catch (e) {
      throw Exception(e);
    }
  }
}
