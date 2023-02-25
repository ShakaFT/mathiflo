import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:intl/intl.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/cuddly_toys_histories_list.dart';
import 'package:mathiflo/widgets/buttons.dart';
import 'package:mathiflo/widgets/popups.dart';
import 'package:mathiflo/widgets/texts.dart';

// ignore: must_be_immutable
class CuddlyToysWidget extends HookWidget {
  CuddlyToysWidget({super.key, required this.histories});

  final CuddlyToysHistoriesNotifier histories;

  int _currentIndex = 0;
  final ValueNotifier _pendingAPI = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: histories,
        builder: (context, items, _) => RefreshIndicator(
          color: mainColor,
          onRefresh: _refresh,
          child: histories.isEmpty
              ? scrollableText("Il n'y a pas encore de nuit.")
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        centerText(
                          _getDateToDisplay(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            border: TableBorder.all(),
                            children: <TableRow>[
                              TableRow(
                                children: [
                                  centerText(
                                    "Mathilde",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  centerText(
                                    "Florent",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              ..._rowToDisplay()
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [..._buttonsToDisplay()],
                        )
                      ],
                    ),
                  ),
                ),
        ),
      );

  String _getDateToDisplay() {
    final date = DateTime.fromMicrosecondsSinceEpoch(
      histories.getAt(_currentIndex).timestamp * 1000 * 1000,
    );

    final result = DateFormat.yMMMMEEEEd("fr").format(date);
    // Set first letter in upper case
    return "${result[0].toUpperCase()}${result.substring(1)}";
  }

  void _nextHistory() {
    // We need to send notification if you want see update in view.
    histories.notify();
    _currentIndex--;
  }

  Future<void> _previousHistory(BuildContext context) async {
    if (histories.length == _currentIndex + 1) {
      _pendingAPI.value = true;
      final worked = await histories.loadNextHistory();
      _pendingAPI.value = false;

      if (!worked) {
        // ignore: use_build_context_synchronously
        snackbar(context, unknownError, error: true);
        return;
      }
    } else {
      // We need to send notification if you want see update in view.
      histories.notify();
    }
    _currentIndex++;
  }

  Future<void> _refresh() async {
    _pendingAPI.value = true;
    await histories.refresh();
    _pendingAPI.value = false;
    _currentIndex = 0;
  }

  List<Widget> _buttonsToDisplay() => [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: _pendingAPI,
            builder: (context, isLoading, _) => previousButton(
              isLoading
                  ? null
                  : () async {
                      await _previousHistory(context);
                    },
              disabled: !histories.getAt(_currentIndex).hasMore,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: _pendingAPI,
            builder: (context, isLoading, _) => nextButton(
              _pendingAPI.value ? null : _nextHistory,
              disabled: _currentIndex == 0,
            ),
          ),
        )
      ];

  List<TableRow> _rowToDisplay() {
    final mathilde = histories.getAt(_currentIndex).mathilde;
    final florent = histories.getAt(_currentIndex).florent;

    final result = <TableRow>[];
    for (var i = 0; i < mathilde.length + florent.length; i++) {
      final forMathilde = mathilde.length > i ? mathilde.elementAt(i) : "";
      final forFlorent = florent.length > i ? florent.elementAt(i) : "";

      if (forMathilde.isEmpty && forFlorent.isEmpty) break;

      result.add(
        TableRow(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    ),
                    height: 50,
                    width: 50,
                  ),
                ),
                centerText(forMathilde),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    ),
                    height: 50,
                    width: 50,
                  ),
                ),
                centerText(forFlorent),
              ],
            ),
          ],
        ),
      );
    }

    return result;
  }
}
