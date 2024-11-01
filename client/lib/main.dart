import 'package:client/app.dart';
import 'package:client/app_settings.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);

    return userAsyncValue.when(
      loading: () {
        print("Initializing app");
        return const LoadingScreen();
      },
      error: (error, stackTrace) {
        print("Initialization error: $error");
        return const ErrorScreen();
      },
      data: (user) {
        final routerNotifier = ref.read(routerProvider.notifier);
        AppSettings.initiateScreens(routerNotifier);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (await ref.read(userProvider.notifier).inSession()) {
            routerNotifier.setPath(context, "home");
          } else {
            routerNotifier.setPath(context, "");
          }
        });

        return const App();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator(color: Colors.orange)),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Text('An error occurred')),
    );
  }
}
