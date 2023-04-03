import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_histories.dart';
import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_network.dart';
import 'package:state_notifier/state_notifier.dart';

class CuddlyToysHistoriesNotifier
    extends StateNotifier<List<CuddlyToysHistory>> {
  CuddlyToysHistoriesNotifier() : super([]);

  bool get isEmpty => state.isEmpty;
  int get length => state.length;

  CuddlyToysHistory getAt(int index) => state[index];

  Future<bool> loadNextHistory() async {
    final history =
        await getNetworkCuddlyToysNight(token: state[length - 1].token);

    if (history == null) {
      return false;
    }

    state = [...state, history];
    return true;
  }

  Future<bool> refresh() async {
    final history = await getNetworkCuddlyToysNight();
    if (history == null) {
      return false;
    }

    state = [history];
    return true;
  }

  notify() {
    state = [...state];
  }
}
