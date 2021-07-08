import 'package:dio/dio.dart';

import '../utils/base_repository.dart';
import '../utils/storage_helper.dart';

class AuthRepository extends Repository {
  Future<void> logIn(String email, String password) async {
    try {
      final result = await dio.post(
        'https://socialmedia.loca.lt/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = result.data['token'];
      await StorageHelper().writeData('token', token);
      final user = await dio.get('https://socialmedia.loca.lt/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await StorageHelper().writeData('user', user.data['data'].toString());
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      final token = await dio.post('https://socialmedia.loca.lt/auth/signup',
          data: {'username': username, 'email': email, 'password': password});
      await StorageHelper().writeData('token', token.data['token']);
      final user = await dio.get('https://socialmedia.loca.lt/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await StorageHelper().writeData('user', user.data['data'].toString());
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    }
  }

  Future<String?>? attemptAutoLogin() async {
    try {
      return await StorageHelper().getData('user');
    } catch (e) {
      throw Exception(e);
    }
  }
}
