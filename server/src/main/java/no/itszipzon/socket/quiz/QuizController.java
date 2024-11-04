package no.itszipzon.socket.quiz;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

/**
 * A controller that handles WebSocket messages.
 */
@Controller
public class QuizController {

  @Autowired
  private SimpMessagingTemplate messagingTemplate;

  @Autowired
  private QuizSessionManager quizSessionManager;

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
      QuizSession quizSession = quizSessionManager.getQuizSession(token);
      quizSession.setMessage("create");
      quizSession.setToken(token);

      messagingTemplate.convertAndSend("/topic/quiz/create/" + message.getUsername(), quizSession);
    }
  }

  /**
   * Sends a message to the client that a player has joined a quiz session.
   *
   * @param message The message containing the token and the username.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/join")
  public void joinQuiz(QuizMessage message) throws Exception {

    if (!quizSessionManager.quizSessionExists(message.getToken())) {
      QuizSession quizSession = new QuizSession();
      quizSession.setMessage("error: Quiz not found");
      messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
          quizSession);
    } else {
      quizSessionManager.addPlayerToQuizSession(message.getToken(), message.getUsername());
      QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());
      quizSession.setMessage("join");
      quizSession.setToken(message.getToken());

      messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(), quizSession);
    }
  }

  /**
   * starts a quiz session.
   *
   * @param message The message containing the token and the username.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/start")
  public void startQuiz(QuizMessage message) throws Exception {

    QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());
    quizSession.setToken(message.getToken());

    if (quizSession.getPlayers().size() < 2) {
      quizSession.setMessage("error: Not enough players");

    } else if (!quizSession.getLeaderUsername().equals(message.getUsername())) {
      quizSession.setMessage("error: Not the leader");

    } else {
      quizSession.setMessage("start");
      
    }
    messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
        quizSession);
  }
}
