import 'package:client/elements/button.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreScreen extends ConsumerStatefulWidget {
   const ScoreScreen(
      {super.key,
      required this.router,
      required this.user,
      required this.values,
      required this.username,
      required this.nextClick,
      required this.end});

  final RouterNotifier router;
  final UserNotifier user;
  final Map<String, dynamic> values;
  final bool end;
  final String username;
  final Function nextClick;

  @override
  ScoreState createState() => ScoreState();
}

class ScoreState extends ConsumerState<ScoreScreen> {
  int quizId = -1;
  String title = "Loading...";
  String token = "";
  List<Map<String, dynamic>> players = [
    {"username": "Loading...", "id": -1, "answers": [], "score": -1}
  ];

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    setState(() {
      quizId = widget.values["quiz"]['id'];
      title = widget.values["quiz"]['title'];
      token = widget.values['token'];
      print("Players: ${widget.values['players']}");
      players = List<Map<String, dynamic>>.from(widget.values['players'])
        ..sort((a, b) => b['score'].compareTo(a['score']));
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          widget.end ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedTextButton(
              text: "Leave",
              onPressed: () => widget.router.setPath(context, 'home'),
              height: 30,
              width: 70,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          )
          :
          widget.username == widget.values["leaderUsername"] ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedTextButton(
              text: "Next",
              onPressed: () => widget.nextClick(),
              height: 30,
              width: 70,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          )
          :
          const SizedBox(width: 0, height: 0,),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            quizId == -1
                ? const SizedBox(
                    height: 200,
                  )
                : Image.network(
                    '${ApiHandler.url}/api/quiz/thumbnail/$quizId',
                    height: 200,
                  ),
            Text(
              "Scores",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 350,
              height: 350,
              child: ListView.builder(
                itemCount: players.length > 5 ? 5 : players.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(players[index]['username'].toString()),
                        Text(players[index]['score'].toString()),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
                child: const SizedBox(
              width: 0,
            )),
          ],
        ),
      ),
    );
  }
}
