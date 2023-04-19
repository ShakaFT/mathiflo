import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_histories_list.dart';
import 'package:state_extended/state_extended.dart';

class CuddlyToysController extends StateXController {
  factory CuddlyToysController() => _this ??= CuddlyToysController._();
  CuddlyToysController._()
      : _cuddlyToys = CuddlyToysHistoriesNotifier(),
        super();

  // Model
  static CuddlyToysController? _this;
  final CuddlyToysHistoriesNotifier _cuddlyToys;
  Map<String, Image>? _cuddlyToysImages;

  int _currentIndex = 0;
  final ValueNotifier _pendingAPI = ValueNotifier(false);

  // Getters
  bool get disabledNextButton => _currentIndex == 0;
  bool get disabledPreviousButton => !_cuddlyToys.getAt(_currentIndex).hasMore;
  CuddlyToysHistoriesNotifier get cuddlyToys => _cuddlyToys;
  Map<String, Image> get cuddlyToysImages => _cuddlyToysImages!;
  List<Map<String, dynamic>> get florentCuddlyToys =>
      _cuddlyToys.getAt(_currentIndex).florent;
  List<Map<String, dynamic>> get mathildeCuddlyToys =>
      _cuddlyToys.getAt(_currentIndex).mathilde;
  ValueNotifier get pendingAPI => _pendingAPI;

  // Methods
  Future<bool> refreshCuddlyToys() async {
    if (_cuddlyToysImages == null) {
      // TODO call API
    }
    _currentIndex = 0;
    return _cuddlyToys.refresh();
  }

  void nextHistory() {
    // We need to send notification if you want see update in view.
    _cuddlyToys.notify();
    _currentIndex--;
  }

  Future<bool> previousHistory() async {
    if (_cuddlyToys.length == _currentIndex + 1) {
      // We need to load the previous history.
      _pendingAPI.value = true;
      final worked = await _cuddlyToys.loadNextHistory();
      _pendingAPI.value = false;

      if (!worked) {
        return false;
      }
    } else {
      // The previous history is already loaded.
      // We need to send notification if you want see update in view.
      _cuddlyToys.notify();
    }

    _currentIndex++;
    return true;
  }

  String nightDate() {
    final date = DateTime.fromMicrosecondsSinceEpoch(
      _cuddlyToys.getAt(_currentIndex).timestamp * 1000 * 1000,
    );

    final result = DateFormat.yMMMMEEEEd("fr").format(date);
    // Set first letter in upper case
    return "${result[0].toUpperCase()}${result.substring(1)}";
  }
}
