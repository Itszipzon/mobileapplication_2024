package no.itszipzon.socket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

/**
 * A controller that handles WebSocket messages.
 */
@Controller
public class QuizController {

  @Autowired
  private SimpMessagingTemplate messagingTemplate;

  @Autowired
  private QuizSessionManager quizSessionManager;

  @MessageMapping("/hello")
  @SendTo("/topic/greetings")
  public Greeting greeting(HelloMessage message) throws Exception {
    System.out.println("Received message: " + message.getName());
    return new Greeting("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
  }

  @MessageMapping("/quiz")
  @SendTo("/topic/quiz")
  public QuizMessage quiz(QuizMessage message) throws Exception {
    System.out.println("Received message: " + message.getQuizId());
    return new QuizMessage(message.getQuizId());
  }

  /**
   * Sends a message to the client that a quiz has been created.
   *
   * @param message The message containing the quiz ID.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/create")
  public void createQuiz(QuizMessage message) throws Exception {
    String token = quizSessionManager.createQuizSession(message);
    if (token == null) {
      messagingTemplate.convertAndSend("/topic/quiz/create/" + message.getUsername(),
          "error: Quiz not found");
    } else {
      messagingTemplate.convertAndSend("/topic/quiz/create/" + message.getUsername(),
          token);
    }
  }
}
