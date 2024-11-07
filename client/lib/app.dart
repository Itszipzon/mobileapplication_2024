import 'package:client/elements/loading.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/app_settings.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerState = ref.watch(routerProvider);
    final theme = AppSettings.getTheme();

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
        ),
        body: Container(child: ref.read(routerProvider.notifier).currentScreen),
      ),
    );
  }
}
