import 'package:client/tools/error_message.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class QuizMessageHandler {

  static String handleSessionMessages(BuildContext context, RouterNotifier router, Map<String, dynamic> values, String username) {
    String value = "";
    String message = values["message"];
    if (message.startsWith("error:")) {
      ErrorHandler.showOverlayError(context, message.substring(7));

      String error = message.substring(7);

      if (error == "Quiz not found") {
        router.setPath(context, "join");
      } else if (error == "User not found") {
        router.setPath(context, "home");
      } else if (error == "Quiz has already started") {
        router.setPath(context, "join");
      }

    } else if (message.startsWith("start")) {
      ErrorHandler.showOverlayError(context, "Quiz has started");

    } else if (message.startsWith("leave: ")) {

      List<String> error = message.substring(7).split(",");

      for (String s in error) {
        print(s);
      }

      if (error[0] == "leader:true") {
        ErrorHandler.showOverlayError(context, "Leader has left the quiz");
        router.setPath(context, "join");
      } else if (error[0] == "leader:false") {
        if (error[1] == " user:$username") {
          ErrorHandler.showOverlayError(context, "You have left the quiz");
          router.setPath(context, "join");
        } else {
          ErrorHandler.showOverlayError(context, "${error[1].substring(6)} has left the quiz");
          value = error[1].substring(6);
        }
      }

    } else if (message.startsWith("end")) {
      ErrorHandler.showOverlayError(context, "Quiz has ended");

    }

    return value;
  }

}