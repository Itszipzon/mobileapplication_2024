import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:flutter/material.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends State<Join> {
  TextEditingController codeController = TextEditingController();
  bool loading = false;

  void onPressed() {
    setState(() {
      loading = true;
    });
    print("Joining session with code: ${codeController.text}");
    codeController.clear();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
