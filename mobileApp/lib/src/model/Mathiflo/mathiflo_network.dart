import 'package:dio/dio.dart';
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: config.defaultRestApiUrl,
    connectTimeout: Duration(seconds: apiTimeout),
    receiveTimeout: Duration(seconds: apiTimeout),
    headers: {config.apiKeyHeader: config.apiKey},
  ),
);

Future<Map<String, dynamic>?> getNetworkAppInfo() async {
  try {
    final response = await dio.get<Map<String, dynamic>>('/app-version');
    return response.data;
  } catch (e) {
    print(e);
    return null;
  }
}
