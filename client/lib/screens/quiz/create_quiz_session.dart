import 'dart:convert';

import 'package:client/elements/loading.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class CreateQuizSession extends ConsumerStatefulWidget {
  const CreateQuizSession({super.key});

  @override
  CreateQuizSessionState createState() => CreateQuizSessionState();
}

class CreateQuizSessionState extends ConsumerState<CreateQuizSession> {
  late RouterNotifier router;
  late UserNotifier user;
  StompClient? stompClient;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      connect();
    });
  }

  void connect() {
    if (router.getValues == null || router.getValues!['quizId'] == null) {
      router.setPath(context, '/quiz');
      return;
    }
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
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {'Origin': ApiHandler.url},
        useSockJS: true,
      ),
    );

    stompClient!.activate();
  }

  Future<void> onConnect(StompFrame frame) async {
    final username = await ApiHandler.getProfile(user.token!).then((value) => value['username']);

    stompClient!.subscribe(
      destination: '/topic/quiz/create/$username',
      callback: (StompFrame frame) {
        final body = frame.body;
        print('Received: $body');
        router.setPath(context, '/quiz/lobby', values: {'token': body.toString()});
      },
    );

    stompClient!.send(
      destination: '/app/quiz/create',
      body: jsonEncode({"quizId": router.getValues!["quizId"], 'username': username}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LogoLoading(),
    );
  }
}
