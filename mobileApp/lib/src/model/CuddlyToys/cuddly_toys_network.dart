import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_histories.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: config.cuddlyToysRestApiUrl,
    connectTimeout: Duration(seconds: apiTimeout),
    receiveTimeout: Duration(seconds: apiTimeout),
    headers: {
      dotenv.env["MATHIFLO_API_KEY_HEADER"]!: dotenv.env["MATHIFLO_API_KEY"]
    },
  ),
);

Future<Map<String, dynamic>?> getStartedData() async {
  try {
    final response = await dio.get<Map<String, dynamic>>('/start');
    return response.data;
  } catch (e) {
    return null;
  }
}

/// If returns null, API call has not worked.
Future<CuddlyToysHistory?> getNetworkCuddlyToysNight({
  String token = "",
}) async {
  try {
    final response =
        await dio.get<Map<String, dynamic>>('/history?token=$token');
    final cuddlyToysData = response.data!;
    return CuddlyToysHistory(
      List<String>.from(cuddlyToysData["Florent"]),
      List<String>.from(cuddlyToysData["Mathilde"]),
      cuddlyToysData["timestamp"],
      hasMore: cuddlyToysData["hasMore"],
      token: cuddlyToysData["token"],
    );
  } catch (e) {
    return null;
  }
}
