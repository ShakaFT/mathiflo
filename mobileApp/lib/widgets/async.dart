import 'package:flutter/material.dart';
import 'package:mathiflo/globals.dart';

waitingApi() => [
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
        builder: (context, isLoading, _) => isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            : const Center(),
      )
    ];
