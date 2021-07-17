import 'package:dio/dio.dart';

import '../utils/base_repository.dart';
import '../utils/storage_helper.dart';

class UserRepository extends Repository {
  Future<Map> getUserByUsername(final username) async {
    try {
      final token = await StorageHelper().getData('token', 'auth');
      final result = await dio.get('https://socialmedia.loca.lt/users/$username',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return result.data['data'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
