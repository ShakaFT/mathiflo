import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/models/cuddly_toys.dart';
import 'package:mathiflo/widgets/buttons.dart';
import 'package:mathiflo/widgets/texts.dart';

// ignore: must_be_immutable
class CuddlyToysWidget extends HookWidget {
  const CuddlyToysWidget({super.key, required this.cuddlyToys});

  final CuddlyToysNotifier cuddlyToys;

  @override
  Widget build(BuildContext context) => StateNotifierBuilder(
        stateNotifier: cuddlyToys,
        builder: (context, items, _) => RefreshIndicator(
          color: mainColor,
          onRefresh: _refresh,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    centerText(
                      "31 Janvier 2023",
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
                          ...rowToDisplay()
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: previousButton(() {}),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: nextButton(() {}),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ],
          ),
        ),
      );

  List<TableRow> rowToDisplay() {
    return [];
    // final mathilde = cuddlyToys.cuddlyToys["Mathilde"]!;
    // final florent = cuddlyToys.cuddlyToys["Florent"]!;

    // final result = <TableRow>[];
    // for (var i = 0; i < mathilde.length + florent.length; i++) {
    //   final forMathilde = mathilde.length > i ? mathilde.elementAt(i) : "";
    //   final forFlorent = florent.length > i ? florent.elementAt(i) : "";

    //   if (forMathilde.isEmpty && forFlorent.isEmpty) break;

    //   result.add(
    //     TableRow(
    //       children: [centerText(forMathilde), centerText(forFlorent)],
    //     ),
    //   );
    // }

    // return result;
  }

  Future<void> _refresh() async {
    if (!await cuddlyToys.refresh()) {}
  }
}
