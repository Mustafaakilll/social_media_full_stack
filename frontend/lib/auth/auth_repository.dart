import 'package:dio/dio.dart';

import '../utils/base_repository.dart';
import '../utils/storage_helper.dart';

class AuthRepository extends Repository {
  Future<void> logIn(String email, String password) async {
    try {
      ///Post Request for user token
      final result = await dio.post(
        'https://socialmedia.loca.lt/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = result.data['token'];

      ///Add token to database
      await StorageHelper().writeData('token', token, 'auth');

      /// Get request for user information
      final user = await dio.get('https://socialmedia.loca.lt/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      ///Add User Infos to database
      await StorageHelper().writeData('user', user.data['data'], 'auth');
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
      await StorageHelper().writeData('token', token.data['token'], 'auth');

      final user = await dio.get('https://socialmedia.loca.lt/auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await StorageHelper().writeData('user', user.data['data'], 'auth');
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    }
  }

  Future<Object?>? attemptAutoLogin() async {
    try {
      return await StorageHelper().getData('token', 'auth');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        StorageHelper().removeItem('token', 'auth'),
        StorageHelper().removeItem('user', 'auth'),
      ]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
