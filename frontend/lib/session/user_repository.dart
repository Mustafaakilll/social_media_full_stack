import 'package:dio/dio.dart';

import '../utils/base_repository.dart';
import '../utils/storage_helper.dart';

class UserRepository extends Repository {
  Future<Map> getUserByUsername(String username) async {
    try {
      final result = await dio.get('http://192.168.1.110:3000/users/$username', options: await dioOptions());
      return result.data['data'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> follow(String userId) async {
    try {
      await dio.get('http://192.168.1.110:3000/users/$userId/follow', options: await dioOptions());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> unfollow(String userId) async {
    try {
      await dio.get('http://192.168.1.110:3000/users/$userId/unfollow', options: await dioOptions());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List> searchUser(String username) async {
    try {
      final response = await dio.get('http://192.168.1.110:3000/users/search',
          queryParameters: {'username': username}, options: await dioOptions());
      return response.data['data'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future editUser(Map data) async {
    try {
      final response = await dio.put('http://192.168.1.110:3000/users', data: data, options: await dioOptions());

      await StorageHelper().removeItem('user', 'auth');
      await StorageHelper().writeData('user', response.data['data'], 'auth');
      return response.data['data'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }
}
