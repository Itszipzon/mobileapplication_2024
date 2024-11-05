import 'dart:convert';

import 'package:client/tools/api_handler.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class QuizGame extends ConsumerStatefulWidget {
  const QuizGame({super.key});

  @override
  QuizGameState createState() => QuizGameState();
}

class QuizGameState extends ConsumerState<QuizGame> {
  late RouterNotifier router;
  late UserNotifier user;
  StompClient? stompClient;

  String state = "quiz";
  Map<String, dynamic> quizData = {"question": "Loading...", "options": []};
  List<Map<String, dynamic>> scores = [{"name": "Loading...", "score": 0}];

  @override
  void initState() {
    super.initState();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      if (user.token == null) {
        router.setPath(context, '');
        return;
      }
      _connectToSocket();
    });
  }

  void _connectToSocket() {
    stompClient = StompClient(
      config: StompConfig(
        url: '${ApiHandler.url}/socket',
        onConnect: _onConnect,
        beforeConnect: () async {
          print('Connecting...');
        },
        onWebSocketError: (dynamic error) =>
            ErrorHandler.showOverlayError(context, 'WebSocket Error: $error'),
        onStompError: (dynamic error) =>
            ErrorHandler.showOverlayError(context, 'STOMP Error: $error'),
        onDisconnect: (frame) =>
            ErrorHandler.showOverlayError(context, 'Disconnected: $frame'),
        webSocketConnectHeaders: {'Origin': ApiHandler.url},
        useSockJS: true,
      ),
    );
  }

  void _onConnect(StompFrame frame) {
    stompClient!.subscribe(
      destination: "/topic/quiz/game/${router.getValues!['token']}",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          setState(() {

          });
        } else {
          ErrorHandler.showOverlayError(context, 'Error: No body');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game'),
      ),
      body: state == "quiz" ? _quizTab() : _scoreTab(),
    );
  }

  Widget _scoreTab() {
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: scores.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Name'),
              subtitle: Text('Score'),
            );
          },
        ),
      ],
    );
  }

  Widget _quizTab() {
    return const Column(
      children: <Widget>[
        Text('Question 1'),
        Text('Answer 1'),
        Text('Answer 2'),
        Text('Answer 3'),
        Text('Answer 4'),
      ],
    );
  }
}
