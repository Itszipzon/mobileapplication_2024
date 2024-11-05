import 'dart:async';
import 'dart:convert';
import 'package:client/elements/button.dart';
import 'package:client/screens/quiz/quiz_message_handler.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/error_message.dart';
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
  String? leader;
  List<String> players = [];
  Completer<void> quizIdCompleter = Completer<void>();

  String username = "";
  String quizName = "";
  String quizId = "";
  int quizTimer = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      if (user.token == null) {
        router.setPath(context, '');
        return;
      }
      _initUsername();
      _connect();
    });
  }

  Future<void> _initUsername() async {
    username = await ApiHandler.getProfile(user.token!)
        .then((value) => value['username']);
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  void _connect() {
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
        onDisconnect: (frame) => _leaveQuiz,
        webSocketConnectHeaders: {'Origin': ApiHandler.url},
        useSockJS: true,
      ),
    );

    stompClient!.activate();
  }

  Future<void> _onConnect(StompFrame frame) async {
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
          setState(() {
            quizToken = result['token'].toString();
            leader = result['leaderUsername'];
            quizName = result['quiz']['title'];
            quizId = result['quizId'].toString();
            quizTimer = result['quiz']['timer'];
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
          if (result['message'] == "join") {
            var mapPlayers = List<Map<String, dynamic>>.from(result['players']);
            if (mounted) {
              setState(() {
                players =
                    mapPlayers.map((p) => p['username'] as String).toList();
                quizName = result['quiz']['title'];
                leader = result['leaderUsername'];
                this.quizId = result['quizId'].toString();
                quizTimer = result['quiz']['timer'];
              });
            }
          } else if (result['message'].toString().startsWith("leave")) {
            if (mounted) {
              setState(() {
                players.remove(QuizMessageHandler.handleSessionMessages(
                    context, router, result, username));
              });
            }
          } else {
            QuizMessageHandler.handleSessionMessages(
                context, router, result, username);
          }
        } else {
          ErrorHandler.showOverlayError(context, 'Empty body');
          router.setPath(context, 'home');
        }
      },
    );
  }

  Future<void> _createQuiz() async {
    stompClient!.send(
      destination: '/app/quiz/create',
      body: json.encode(
          {'quizId': router.getValues!['id'], "userToken": user.token!}),
    );
  }

  void _joinQuiz() {
    stompClient!.send(
      destination: '/app/quiz/join',
      body: json.encode({
        'token': router.getValues!['id'],
        "userToken": user.token!,
      }),
    );
  }

  void _startQuiz() {
    stompClient!.send(
      destination: '/app/quiz/start',
      body: json.encode({
        'token': quizToken,
        "userToken": user.token!,
      }),
    );
  }

  void _leaveQuiz() {
    stompClient!.send(
      destination: '/app/quiz/leave',
      body: json.encode({
        'token': quizToken,
        "userToken": user.token!,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.canvasColor,
        body: Column(
          children: [
            const SizedBox(height: 8),
            quizId == ""
                ? const SizedBox(
                    height: 200,
                  )
                : Image(
                    image: NetworkImage(
                        '${ApiHandler.url}/api/quiz/thumbnail/$quizId'),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Session token: $quizToken',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: TextField(
                            controller: TextEditingController(
                                text: quizTimer.toString()),
                            readOnly: leader != username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Players: ${players.length}"),
            ]),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 550,
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
            ),
            username == leader
                ? Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 16,),
                          SizedTextButton(
                            text: "Start",
                            onPressed: _startQuiz,
                            height: 50,
                            width: 200,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          SizedTextButton(
                            text: "Leave",
                            onPressed: _leaveQuiz,
                            inversed: true,
                            height: 50,
                            width: 200,
                            textStyle: const TextStyle(
                                color: Colors.orange,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16,),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: SizedTextButton(
                        text: "Leave",
                        onPressed: _leaveQuiz,
                        inversed: true,
                        height: 50,
                        width: 200,
                        textStyle: const TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
          ],
        ));
  }
}