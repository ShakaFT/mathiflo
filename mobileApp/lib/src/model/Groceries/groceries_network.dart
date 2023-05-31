import 'package:dio/dio.dart';
import 'package:mathiflo/config.dart' as config;
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/Groceries/groceries_item.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: config.groceriesRestApiUrl,
    connectTimeout: const Duration(seconds: apiTimeout),
    receiveTimeout: const Duration(seconds: apiTimeout),
    headers: {config.apiKeyHeader: config.apiKey},
  ),
);

/// If returns null, API call has not worked.
Future<List<Item>?> getNetworkGroceries() async {
  try {
    final response = await dio.get<Map<String, dynamic>>('/groceries');
    final groceriesList = <Item>[];

    for (final item in response.data!['groceries_list']) {
      groceriesList.add(Item.fromMap(item));
    }
    return groceriesList;
  } catch (e) {
    return null;
  }
}

Future<String> addNetworkGroceriesItem(Item item) async {
  try {
    final response = await dio.post<Map<String, dynamic>>(
      '/groceries/${item.id}',
      data: item.toMap(),
    );

    if (response.data!['exists']) {
      return "Cet article existe déjà, mets à jour ta liste de courses.";
    }

    return "";
  } catch (e) {
    return unknownError;
  }
}

Future<String> updateNetworkGroceriesItem(Item item) async {
  try {
    final response = await dio.put<Map<String, dynamic>>(
      '/groceries/${item.id}',
      data: item.toMap(),
    );

    final groceriesData = response.data!;
    if (groceriesData["exists"] == false) {
      return "Un article possède déjà ce nom, mets à jour ta liste de courses.";
    }
    if (groceriesData["deleted"] == true) {
      return "Cet article a été supprimé, mets à jour ta liste de courses.";
    }

    return "";
  } catch (e) {
    return unknownError;
  }
}

Future<bool> deleteNetworkGroceriesItems(
  List<String> toDelete, {
  all = false,
}) async {
  try {
    await dio
        .delete('/groceries', data: {'all': all, 'groceries_items': toDelete});
    return true;
  } catch (e) {
    return false;
  }
}
