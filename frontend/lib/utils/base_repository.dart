import 'package:dio/dio.dart';

import 'storage_helper.dart';

abstract class Repository {
  Future<Object> get token async => await StorageHelper().getData('token', 'auth');
  final dio = Dio();
  Future<Options> dioOptions() async => Options(headers: {'Authorization': 'Bearer ${await token}'});
}
