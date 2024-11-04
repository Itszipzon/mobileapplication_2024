import 'package:client/tools/error_message.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class QuizMessageHandler {

  static void handleSessionMessages(BuildContext context, RouterNotifier router, Map<String, dynamic> values) {
    String message = values["message"];
    if (message.startsWith("error:")) {
      ErrorHandler.showOverlayError(context, message.substring(7));

      String error = message.substring(7);

      if (error == "Quiz not found") {
        router.setPath(context, "join");
      }

    } else if (message.startsWith("start")) {
      router.setPath(context, "/quiz/start", values: values);

    }
  }

}