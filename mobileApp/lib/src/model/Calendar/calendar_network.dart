import 'package:dio/dio.dart';
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: config.calendarRestApiUrl,
    connectTimeout: const Duration(seconds: apiTimeout),
    receiveTimeout: const Duration(seconds: apiTimeout),
    headers: {config.apiKeyHeader: config.apiKey},
  ),
);

/// If returns null, API call has not worked.
Future<List<Event>?> getNetworkEvents(
  int startTimestamp,
  int endTimestamp,
) async {
  try {
    final response = await dio.get<Map<String, dynamic>>(
      "/events?start_timestamp=$startTimestamp&end_timestamp=$endTimestamp",
    );
    final events = <Event>[];

    for (final event in response.data!['events']) {
      events.add(Event.fromMap(event));
    }
    return events;
  } catch (e) {
    return null;
  }
}

Future<bool> addNetworkEvent(Event event) async {
  try {
    await dio.post("/event/${event.id}", data: event.toMap());
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> updateNetworkEvent(Event event) async {
  try {
    await dio.put("/event/${event.id}", data: event.toMap());
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteNetworkEvent(Event event) async {
  try {
    await dio.delete("/event/${event.id}");
    await Future.delayed(const Duration(milliseconds: 5000));
    return true;
  } catch (e) {
    return false;
  }
}
