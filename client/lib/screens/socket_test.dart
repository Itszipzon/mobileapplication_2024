import 'dart:convert';

import 'package:client/tools/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketTest extends StatefulWidget {
  const SocketTest({super.key});

  @override
  SocketTestState createState() => SocketTestState();
}

class SocketTestState extends State<SocketTest> {
  StompClient? stompClient;
  String greeting = '';
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connect();
  }

void connect() {
  stompClient = StompClient(
    config: StompConfig(
      url: '${ApiHandler.url}/gs-guide-websocket',
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
      destination: '/topic/greetings',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var result = json.decode(frame.body!);
          setState(() {
            greeting = result['content'];
          });
        }
      },
    );
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendName,
              child: const Text('Send'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Greeting from server:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              greeting,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
