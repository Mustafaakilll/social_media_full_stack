import 'package:dio/dio.dart';

import '../base_repository.dart';

class AuthRepository extends Repository {
  Future<String> logIn(String email, String password) async {
    try {
      final result = await dio.post(
        'https://socialmedia.loca.lt/auth/login',
        data: {'email': email, 'password': password},
      );
      return result.data['token'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    }
  }

  Future<String> signUp(String username, String email, String password) async {
    try {
      final result = await dio.post('https://socialmedia.loca.lt/auth/signup',
          data: {'username': username, 'email': email, 'password': password});
      return result.data['token'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    }
  }
}
