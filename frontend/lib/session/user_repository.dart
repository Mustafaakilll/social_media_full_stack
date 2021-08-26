import 'package:dio/dio.dart';

import '../utils/base_repository.dart';
import '../utils/storage_helper.dart';

class UserRepository extends Repository {
  Future<Map> getUserByUsername(final username) async {
    try {
      final token = await StorageHelper().getData('token', 'auth');
      final result = await dio.get('http://192.168.1.107:3000/users/$username',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return result.data['data'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
