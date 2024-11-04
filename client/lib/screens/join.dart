import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Join extends ConsumerStatefulWidget {
  const Join({super.key});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends ConsumerState<Join> {
  TextEditingController codeController = TextEditingController();
  bool loading = false;
  late final RouterNotifier router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
    });
  }

  void onPressed() {
    setState(() {
      loading = true;
    });
    router.setPath(context, 'quiz/lobby', values: {'id': codeController.text, 'create': false});
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Input(
                    labelText: "Session token", controller: codeController, onReturn: (_) => onPressed(),),
              ),
              const SizedBox(width: 5),
              SizedTextButton(
                text: "Join",
                onPressed: onPressed,
                loading: loading,
                height: 55,
                width: 55,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "join"),
    );
  }
}
