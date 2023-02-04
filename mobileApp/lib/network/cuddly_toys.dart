import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathiflo/config/config.dart' as config;
import 'package:mathiflo/models/cuddly_toys_histories.dart';

Future<CuddlyToysHistory?> getNetworkCuddlyToysNight({
  String token = "",
}) async {
  // If returns null, API call has not worked
  final uri = Uri.tryParse(
    '${config.cuddlyToysUrl}/history?token=$token',
  )!;

  try {
    final response = await http.get(uri);

    if (response.statusCode < 200 || response.statusCode > 299) {
      return null;
    }
    final Map<String, dynamic> decodedPayload = json.decode(response.body);
    return CuddlyToysHistory(
      decodedPayload["Florent"].cast<String>(),
      decodedPayload["Mathilde"].cast<String>(),
      decodedPayload["timestamp"],
      hasMore: decodedPayload["hasMore"],
      token: decodedPayload["token"],
    );
  } catch (e) {
    return null;
  }
}

Future<bool> updateNetworkCuddlyToysNight(CuddlyToysHistory history) async {
  final uri = Uri.tryParse(
    '${config.cuddlyToysUrl}/history',
  )!;

  final encodedPayload = jsonEncode(history.toMap());
  try {
    final response = await http.put(uri, body: encodedPayload);
    return response.statusCode >= 200 && response.statusCode <= 299;
  } catch (e) {
    return false;
  }
}
