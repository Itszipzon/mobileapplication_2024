import 'dart:convert';

import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketTest extends ConsumerStatefulWidget {
  const SocketTest({super.key});

  @override
  SocketTestState createState() => SocketTestState();
}

class SocketTestState extends ConsumerState<SocketTest> {
  late RouterNotifier router;
  late UserNotifier user;
  StompClient? stompClient;
  String quiz = '';
  String username = "";
  TextEditingController nameController = TextEditingController();

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
    username = await ApiHandler.getProfile(user.token!).then((value) => value['username']);
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
        // Optional headers
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {'Origin': ApiHandler.url},
        useSockJS: true,
      ),
    );

    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {

    stompClient!.subscribe(
      destination: "/topic/quiz",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          print(result);
          setState(() {
            quiz = result['quizId'].toString();
          });
        } else {
          print('Empty body');
        }
      },
    );



    stompClient!.subscribe(
      destination: "/topic/quiz/create/$username",
      callback: (StompFrame frame) {
        print("Received quiz id: ${frame.body}");
        if (frame.body != null) {
          var result = frame.body!;
          print("result: $result");
          setState(() {
            quiz = result;
          });
        } else {
          print('Empty body');
        }
      },
      );

    createQuiz();
  }

  void sendName() {
    if (nameController.text.isNotEmpty) {
      stompClient!.send(
        destination: '/app/hello',
        body: json.encode({'name': nameController.text}),
      );
      nameController.clear();
    }
  }

  void createQuiz() {
    stompClient!.send(
      destination: '/app/quiz/create',
      body: json.encode({'quizId': router.getValues!['id'], "username" : username}),
    );
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),
            const Text(
              'Id:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              quiz,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
