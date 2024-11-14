import 'dart:convert';

import 'package:client/elements/button.dart';
import 'package:client/elements/counter.dart';
import 'package:client/screens/quiz/socket/quiz_socket_answers.dart';
import 'package:client/screens/quiz/socket/quiz_socket_question.dart';
import 'package:client/screens/quiz/socket/quiz_socket_score.dart';
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

  String username = "";
  String thumbnail = "";
  String title = "Loading...";
  int timer = 0;
  String state = "countdown";
  int questionNumber = 0;
  bool isLoading = true;
  String message = "";

  Map<String, dynamic> values = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      if (user.token == null) {
        router.setPath(context, 'login');
        return;
      }
      _initUsername();
      _initStates();
      _connectToSocket();
    });
  }

  Future<void> _initUsername() async {
    username = await ApiHandler.getProfile(user.token!)
        .then((value) => value['username']);
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

    print(router.getValues!);
    setState(() {
      title = router.getValues!['quiz']['title'];
      timer = router.getValues!['quiz']['timer'];
      thumbnail = router.getValues!['thumbnail'];
      values = router.getValues!;
      values['message'] = {"message": "firstCountDown"};
      values['username'] = username;
      isLoading = false;
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

    stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    stompClient!.subscribe(
      destination: "/topic/quiz/game/session/${router.getValues!['token']}",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          setState(() {
            state = result['state'];
            title = result["quiz"]['title'];
            timer = result["quiz"]['timer'];
            message = result['message'];
            values = result;
            values['username'] = username;
          });
          _displaySelectedScene();
        } else {
          ErrorHandler.showOverlayError(context, 'Error: No body');
        }
      },
    );
  }

  Future<void> _handleQuizTimer(bool showAnswers) async {
    stompClient!.send(
      destination: "/app/quiz/game",
      body: json.encode({
        "token": router.getValues!['token'],
        "message": {"message": "next", "quizState": showAnswers ? "showAnswer" : "quiz"},
        "userToken": user.token,
        "quizId": router.getValues!['quiz']['id'],
      }),
    );
    _displaySelectedScene();
  }

  Future<void> _handleNext() async {
    stompClient!.send(
      destination: "/app/quiz/game",
      body: json.encode({
        "token": router.getValues!['token'],
        "message": {"message": "next"},
        "userToken": user.token,
        "quizId": router.getValues!['quiz']['id'],
      }),
    );
    _displaySelectedScene();
  }

  _handleAnswer(Map<String, dynamic> data) async {
    final String answer = data['answer'];
    final int answerId = data['answerId'];

    final Map<String, dynamic> message = {
      "message": "answer",
      "answer": answer,
      "answerId": answerId,
    };

    final Map<String, dynamic> answerMap = {
      "token": router.getValues!['token'],
      "userToken": user.token,
      "quizId": router.getValues!['quiz']['id'],
      "answerId": answerId,
      "message": message,
    };
    stompClient!.send(
      destination: "/app/quiz/game",
      body: json.encode(answerMap),
    );
  }

  Widget _displaySelectedScene() {
    if (state == "quiz") {
      if (message == "showAnswer") {
        return QuizSocketAnswers(
          router: router,
          user: user,
          values: values,
          onTimer: (data) => {
            _handleQuizTimer(data)
          },
          onClick: (data) => _handleAnswer(data),
        );
      } else {
        return QuizSocketQuestion(
          router: router,
          user: user,
          values: values,
          onTimer: (data) => {
            _handleQuizTimer(data)
          },
          onClick: (data) => _handleAnswer(data),
        );
      }
    } else if (state == "score") {
      return ScoreScreen(
        router: router,
        user: user,
        values: values,
        username: username,
      );
    } else if (state == "end") {
      return ScoreScreen(
        router: router,
        user: user,
        values: values,
        username: username,
      );
    } else {
      return Counter(onCountdownComplete: _handleNext, duration: 5, marginTop: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          state == "score" && username == values['leaderUsername']
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedTextButton(
                    text: "Next",
                    onPressed: _handleNext,
                    height: 30,
                    width: 70,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              : const SizedBox(
                  width: 0,
                ),
          state == "end"
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedTextButton(
                    text: "Leave",
                    onPressed: () {
                      router.setPath(context, 'join');
                    },
                    height: 30,
                    width: 70,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              : const SizedBox(
                  width: 0,
                ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            !isLoading
                ? Image.network(
                    '${ApiHandler.url}/api/quiz/thumbnail/${values['quiz']['id']}',
                    height: 200,
                  )
                : const SizedBox(
                    height: 200,
                  ),
            _displaySelectedScene()
          ],
        ),
      ),
    );
  }
}
