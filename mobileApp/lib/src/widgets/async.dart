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
            builder: (context, isLoading, _) =>
                isLoading ? _lockScreen() : const Center(),
          ),
          ValueListenableBuilder(
            valueListenable: pendingAPI,
            builder: (context, isLoading, _) =>
                isLoading ? _circularProgressIndicator() : const Center(),
          )
        ],
      );
}

Widget loader({lockScreen = false}) => lockScreen
    ? Stack(
        children: [_circularProgressIndicator(), _lockScreen()],
      )
    : _circularProgressIndicator();

Widget _circularProgressIndicator() => Center(
      child: CircularProgressIndicator(color: mainColor),
    );

Widget _lockScreen() => const Opacity(
      opacity: 0.2,
      child: ModalBarrier(
        color: Colors.black,
      ),
    );
