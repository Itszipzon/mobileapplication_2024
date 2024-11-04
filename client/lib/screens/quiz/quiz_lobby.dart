import 'dart:async';
import 'dart:convert';

import 'package:client/screens/quiz/quiz_message_handler.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class QuizLobby extends ConsumerStatefulWidget {
  const QuizLobby({super.key});

  @override
  QuizLobbyState createState() => QuizLobbyState();
}

class QuizLobbyState extends ConsumerState<QuizLobby> {
  late RouterNotifier router;
  late UserNotifier user;
  StompClient? stompClient;
  String quizToken = '';
  String username = "";
  List<String> players = [];
  Completer<void> quizIdCompleter = Completer<void>();

  String quizName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      initUsername();
      connect();
    });
  }

  Future<void> initUsername() async {
    username = await ApiHandler.getProfile(user.token!)
        .then((value) => value['username']);
  }

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: '${ApiHandler.url}/socket',
        onConnect: onConnect,
        beforeConnect: () async {
          print('Waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('Connecting...');
        },
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        onStompError: (dynamic error) => print('STOMP Error: $error'),
        onDisconnect: (frame) => print('Disconnected'),
        webSocketConnectHeaders: {'Origin': ApiHandler.url},
        useSockJS: true,
      ),
    );

    stompClient!.activate();
  }

  Future<void> onConnect(StompFrame frame) async {
    if (bool.parse(router.getValues!["create"].toString())) {
      _subscribeToCreate();
      await _createQuiz();
      await quizIdCompleter.future;
      _subscribeToJoin(quizToken);
      setState(() {
        players.add(username);
      });
    } else {
      setState(() {
        quizToken = router.getValues!['id'].toString();
      });
      _subscribeToJoin(quizToken);
      _joinQuiz();
    }
  }

  void _subscribeToCreate() {
    stompClient!.subscribe(
      destination: "/topic/quiz/create/$username",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          print("result: ${frame.body}");
          setState(() {
            quizToken = result['token'].toString();
            quizName = result['quiz']['title'];
          });
          quizIdCompleter.complete();
        } else {
          print('Empty body');
        }
      },
    );
  }

  void _subscribeToJoin(String quizId) {
    stompClient!.subscribe(
      destination: "/topic/quiz/session/$quizId",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          print("result: $result");
          if (result['message'] == "join") {
            var mapPlayers = List<Map<String, dynamic>>.from(result['players']);
            setState(() {
              players = mapPlayers.map((p) => p['username'] as String).toList();
              quizName = result['quiz']['title'];
            });
          } else if (result['message'] == "leave") {
            setState(() {
              players.remove(result['username']);
            });
          } else {
            QuizMessageHandler.handleSessionMessages(context, router, result);
          }
        } else {
          print('Empty body');
        }
      },
    );
  }

  Future<void> _createQuiz() async {
    stompClient!.send(
      destination: '/app/quiz/create',
      body: json.encode({'quizId': router.getValues!['id'], "username": username}),
    );
  }

  void _joinQuiz() {
    stompClient!.send(
      destination: '/app/quiz/join',
      body: json.encode({
        'token': router.getValues!['id'],
        "username": username,
      }),
    );

    stompClient!.subscribe(
      destination: "/topic/quiz/join/${router.getValues!['id']}",
      callback: (StompFrame frame) {
        print("Received players: ${frame.body}");
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          print("result: $result");
          setState(() {
            players = List<String>.from(result);
          });
        } else {
          print('Empty body');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        backgroundColor: theme.canvasColor,
        title: Row(
          children: [
            Text(quizName),
            const SizedBox(width: 8),
            Text(quizToken),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (int i = 0; i < players.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(players[i]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

