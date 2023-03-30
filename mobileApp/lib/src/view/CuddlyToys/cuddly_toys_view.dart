import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/model/CuddlyToys/cuddly_toys_histories_list.dart';
import 'package:mathiflo/src/view/CuddlyToys/widgets/cuddly_toys.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:mathiflo/src/widgets/popups.dart';

useCuddlyToysView() => use(const _CuddlyToysView());

class _CuddlyToysView extends Hook<void> {
  const _CuddlyToysView();

  @override
  _CuddlyToysViewState createState() => _CuddlyToysViewState();
}

class _CuddlyToysViewState extends HookState<void, _CuddlyToysView> {
  late CuddlyToysHistoriesNotifier cuddlyToys = CuddlyToysHistoriesNotifier();

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: appBar("Doudous"),
          body: FutureBuilder(
            // ignore: discarded_futures
            future: _loadCuddlyToysHistories(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? loader()
                    : HookBuilder(
                        builder: (context) =>
                            CuddlyToysWidget(histories: cuddlyToys),
                      ),
          ),
          drawer: const NavigationDrawerWidget(),
        ),
        onWillPop: () async => false,
      );

  // Action methods

  Future<void> _loadCuddlyToysHistories() async {
    if (!await cuddlyToys.refresh()) {
      // ignore: use_build_context_synchronously
      snackbar(context, unknownError, error: true);
    }
  }
}
