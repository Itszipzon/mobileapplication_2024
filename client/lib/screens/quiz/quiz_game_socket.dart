import 'dart:convert';

import 'package:client/screens/quiz/quiz_start_timer.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class QuizGameSocket extends ConsumerStatefulWidget {
  const QuizGameSocket({super.key});

  @override
  QuizGameSocketState createState() => QuizGameSocketState();
}

class QuizGameSocketState extends ConsumerState<QuizGameSocket> {
  late RouterNotifier router;
  late UserNotifier user;
  StompClient? stompClient;
  late Widget scene;

  String thumbnail = "";
  String title = "Loading...";
  int timer = 0;
  String state = "countdown";
  Map<String, dynamic> quizData = {"question": "Loading...", "options": [{}]};
  List<Map<String, dynamic>> scores = [{"name": "Loading...", "score": 0}];

  @override
  void initState() {
    super.initState();
    scene = QuizStartTimer(onCountdownComplete: _timerComplete);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      if (user.token == null) {
        router.setPath(context, 'login');
        return;
      }
      _initStates();
      _connectToSocket();
    });
  }

  void _initStates() {
    if (router.getValues == null) {
      router.setPath(context, 'join');
      return;
    }
    if (router.getValues!['token'] == null) {
      router.setPath(context, 'join');
      return;
    }

    setState(() {
      title = router.getValues!['quiz']['title'];
      timer = router.getValues!['quiz']['timer'];
      thumbnail = router.getValues!['thumbnail'];
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
            state = result['state'];
            quizData = result['quizData'];
            quizData['options'] = _randomizeOptions(quizData['options']);
            scores = _filterScores(result['scores']);
            title = result['title'];
            timer = result['timer'];
          });
        } else {
          ErrorHandler.showOverlayError(context, 'Error: No body');
        }
      },
    );
  }

  List<Map<String, dynamic>> _filterScores(List<Map<String, dynamic>> values) {
    values.sort((a, b) => b['score'].compareTo(a['score']));
    return values;
  }

  List<Map<String, dynamic>> _randomizeOptions(List<Map<String, dynamic>> values) {
    values.shuffle();
    return values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: scene,
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
              title: Text(scores[index]['name']),
              subtitle: Text(scores[index]['score'].toString()),
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

  _displaySelectedScene() {
    if (state == "quiz") {
      setState(() {
        scene = _quizTab();
      });
    } else if (state == "score") {
      setState(() {
        scene = _scoreTab();
      });
    } else {
      setState(() {
        scene = QuizStartTimer(onCountdownComplete: _timerComplete,);
      });
    }
  }

  void _timerComplete() {
    setState(() {
      state = "quiz";
    });
    _displaySelectedScene();
  }
}
