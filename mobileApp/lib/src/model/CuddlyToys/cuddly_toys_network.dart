import 'package:dio/dio.dart';
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_histories.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: config.cuddlyToysRestApiUrl,
    connectTimeout: Duration(seconds: apiTimeout),
    receiveTimeout: Duration(seconds: apiTimeout),
  ),
);

/// If returns null, API call has not worked.
Future<CuddlyToysHistory?> getNetworkCuddlyToysNight({
  String token = "",
}) async {
  try {
    final response =
        await dio.get<Map<String, dynamic>>('/history?token=$token');
    final cuddlyToysData = response.data!;

    return CuddlyToysHistory(
      List<Map<String, dynamic>>.from(cuddlyToysData["Florent"]),
      List<Map<String, dynamic>>.from(cuddlyToysData["Mathilde"]),
      cuddlyToysData["timestamp"],
      hasMore: cuddlyToysData["hasMore"],
      token: cuddlyToysData["token"],
    );
  } catch (e) {
    return null;
  }
}
