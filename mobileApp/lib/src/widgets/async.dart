import 'package:flutter/material.dart';
import 'package:mathiflo/config.dart';
import 'package:mathiflo/constants.dart';

// This widget allows to add a load while the rest API is called.
// The screen is not clickable.
class WaitingApi extends StatelessWidget {
  const WaitingApi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          ValueListenableBuilder(
            valueListenable: pendingAPI,
            builder: (context, isLoading, _) => isLoading
                ? const Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(
                      color: Colors.black,
                    ),
                  )
                : const Center(),
          ),
          ValueListenableBuilder(
            valueListenable: pendingAPI,
            builder: (context, isLoading, _) =>
                isLoading ? circularProgressIndicator() : const Center(),
          )
        ],
      );
}

Widget circularProgressIndicator() => Center(
      child: CircularProgressIndicator(color: mainColor),
    );
