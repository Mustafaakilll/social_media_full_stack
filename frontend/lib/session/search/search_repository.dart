import 'package:dio/dio.dart';

import '../../utils/base_repository.dart';

class SearchRepository extends Repository {
  Future<List> searchUser(String username) async {
    try {
      final response = await dio.get('http://192.168.1.107:3000/users',
          queryParameters: {'username': username},
          options: Options(headers: {'Authorization': 'Bearer ${await token}'}));
      return response.data['data'];
    } on DioError catch (e) {
      throw Exception(e.response!.data['message']);
    } catch (e) {
      throw Exception(e);
    }
  }
}
