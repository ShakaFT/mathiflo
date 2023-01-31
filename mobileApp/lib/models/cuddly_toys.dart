import 'package:state_notifier/state_notifier.dart';

class CuddlyToysNotifier extends StateNotifier<Map<String, List<String>>> {
  CuddlyToysNotifier() : super({});

  // Public methods

  Map<String, List<String>> get cuddlyToys => state;

  Future<bool> refresh() async {
    // final groceriesList = await getNetworkGroceries();
    // if (groceriesList is List<Item>) {
    //   state = groceriesList;
    //   _sort();
    //   return true;
    // }
    // return false;
    return Future.delayed(const Duration(milliseconds: 1000), () => true);
  }
}
