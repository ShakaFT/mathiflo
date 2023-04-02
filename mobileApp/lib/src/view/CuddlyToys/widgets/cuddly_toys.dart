import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/CuddlyToys/cuddly_toys_controller.dart';
import 'package:mathiflo/src/widgets/buttons.dart';
import 'package:mathiflo/src/widgets/popups.dart';
import 'package:mathiflo/src/widgets/texts.dart';

class CuddlyToysWidget extends StatelessWidget {
  const CuddlyToysWidget({super.key, required this.controller});

  final CuddlyToysController controller;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: controller.cuddlyToys,
        builder: (context, items, _) => controller.cuddlyToys.isEmpty
            ? scrollableText("Il n'y a pas encore de nuit.")
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      centerText(
                        controller.nightDate(),
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
                            ..._rowToDisplay(context)
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
      );

  List<Widget> _buttonsToDisplay() => [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: controller.pendingAPI,
            builder: (context, isLoading, _) => previousButton(
              isLoading
                  ? null
                  : () async {
                      await _previousHistory(context);
                    },
              disabled: controller.disabledPreviousButton,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: pendingAPI,
            builder: (context, isLoading, _) => nextButton(
              isLoading ? null : controller.nextHistory,
              disabled: controller.disabledNextButton,
            ),
          ),
        )
      ];

  _previousHistory(BuildContext context) async {
    if (!await controller.previousHistory()) {
      if (context.mounted) snackbar(context, unknownError, error: true);
    }
  }

  List<TableRow> _rowToDisplay(BuildContext context) {
    final florent = controller.florentCuddlyToys;
    final mathilde = controller.mathildeCuddlyToys;
    final result = <TableRow>[];

    for (var i = 0; i < mathilde.length + florent.length; i++) {
      final forMathilde = mathilde.length > i
          ? mathilde.elementAt(i)
          : {'name': '', 'image_url': ''};
      final forFlorent = florent.length > i
          ? florent.elementAt(i)
          : {'name': '', 'image_url': ''};

      if (forMathilde["name"]!.isEmpty && forFlorent["name"]!.isEmpty) break;

      result.add(
        TableRow(
          children: [
            Row(
              children: [
                if (forMathilde["name"]! != "")
                  avatarImage(context, forMathilde["image_url"]!),
                centerText(forMathilde["name"]!),
              ],
            ),
            Row(
              children: [
                if (forFlorent["name"]! != "")
                  avatarImage(context, forFlorent["image_url"]!),
                centerText(forFlorent["name"]!),
              ],
            ),
          ],
        ),
      );
    }

    return result;
  }
}
