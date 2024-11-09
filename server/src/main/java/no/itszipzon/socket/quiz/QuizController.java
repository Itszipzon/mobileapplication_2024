package no.itszipzon.socket.quiz;

import io.jsonwebtoken.Claims;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import no.itszipzon.config.JwtUtil;
import no.itszipzon.dto.QuizQuestionDto;
import no.itszipzon.repo.QuizQuestionRepo;
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

  @Autowired
  private JwtUtil jwtUtil;

  @Autowired
  private QuizQuestionRepo quizQuestionRepo;

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

    Claims claims = jwtUtil.extractClaims(message.getUserToken());

    if (claims == null) {
      messagingTemplate.convertAndSend("/topic/quiz/create/" + message.getUserToken(),
          "error: User not found");
      return;
    }

    String username = claims.getSubject();

    if (token == null) {
      messagingTemplate.convertAndSend("/topic/quiz/create/" + username, "error: Quiz not found");
    } else {
      QuizSession quizSession = quizSessionManager.getQuizSession(token);
      quizSession.setMessage("create");
      quizSession.setToken(token);

      messagingTemplate.convertAndSend("/topic/quiz/create/" + username,
          getQuizDetailsFromSessionNoQuestions(quizSession));
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
      messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(), quizSession);
    } else {
      QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());
      if (quizSession.isStarted()) {
        QuizSession newQuizSession = new QuizSession();
        newQuizSession.setMessage("error: Quiz has already started");
        newQuizSession.setStarted(true);
        messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
            newQuizSession);
        return;
      } else {
        quizSession.addPlayer(quizSessionManager.getPlayer(message.getUserToken()));
        quizSession.setMessage("join");
        quizSession.setToken(message.getToken());

        messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
            getQuizDetailsFromSessionNoQuestions(quizSession));
      }
    }
  }

  /**
   * Sends a message to the client that the leader changed the quiz settings.
   *
   * @param message The message containing the token and the username.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/session/settings")
  public void settings(QuizMessage message) throws Exception {
    QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());
    Claims claims = jwtUtil.extractClaims(message.getUserToken());
    if (quizSession.getLeaderUsername().equals(claims.getSubject())) {
      quizSession.setMessage("settings");
      Map<String, Object> socketMessage = message.getMessage();

      if (socketMessage.containsKey("setNewQuiz") && (boolean) socketMessage.get("setNewQuiz")) {
        QuizSession newQuizSession = new QuizSession(quizSession.getLeaderUsername(),
            (int) socketMessage.get("quizId"));
        newQuizSession.setPlayers(quizSession.getPlayers());
        newQuizSession.setToken(quizSession.getToken());
        newQuizSession.setMessage("update");

        ;

        if (quizSessionManager.setNewQuiz(newQuizSession)) {
          quizSession = newQuizSession;
        } else {
          quizSession.setMessage("error:onlyleader: Quiz not found");
        }
      }

      if (socketMessage.containsKey("changeTimer") && (boolean) socketMessage.get("changeTimer")) {
        quizSession.getQuiz().setTimer((int) socketMessage.get("timer"));
        quizSession.setMessage("update");
      }

      messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
          getQuizDetailsFromSessionNoQuestions(quizSession));
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

    Claims claims = jwtUtil.extractClaims(message.getUserToken());

    if (quizSession.getPlayers().size() < 2) {
      quizSession.setMessage("error: Not enough players");

    } else if (!quizSession.getLeaderUsername().equals(claims.getSubject())) {
      quizSession.setMessage("error: Not the leader");

    } else {
      quizSession.setStarted(true);
      quizSession.setMessage("start");
      quizSession.setState("start");

    }
    messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
        getQuizDetailsFromSessionNoQuestions(quizSession));
  }

  /**
   * Sends a message to the client that a player has left a quiz session.
   *
   * @param message The message containing the token and the username.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/leave")
  public void leaveQuiz(QuizMessage message) throws Exception {
    QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());

    Claims claims = jwtUtil.extractClaims(message.getUserToken());
    String leaveMessage = "";
    if (claims.getSubject().equalsIgnoreCase(quizSession.getLeaderUsername())) {
      leaveMessage = "leave: leader:true, user:" + claims.getSubject();
      quizSessionManager.deleteQuizSession(message.getToken());
    } else {
      leaveMessage = "leave: leader:false, user:" + claims.getSubject();
    }

    quizSession.removePlayer(claims.getSubject());
    quizSession.setMessage(leaveMessage);
    quizSession.setToken(message.getToken());

    System.out.println("leaveMessage: " + claims.getSubject());

    messagingTemplate.convertAndSend("/topic/quiz/session/" + message.getToken(),
        getQuizDetailsFromSessionNoQuestions(quizSession));
  }

  /**
   * Sends a message to the client that a player has left a quiz session.
   *
   * @param message The message containing the token and the username.
   * @throws Exception If the message cannot be sent.
   */
  @MessageMapping("/quiz/game")
  public void game(QuizMessage message) throws Exception {
    QuizSession quizSession = quizSessionManager.getQuizSession(message.getToken());
    quizSession.setToken(message.getToken());

    String messageType = message.getMessage().get("message").toString();

    switch (messageType) {
      case "firstCountDown":
        handleFirstCountDown(quizSession, message.getToken());
        break;

      case "next":
        handleNext(quizSession, message);
        break;

      case "answer":
        handleAnswer(quizSession, message);
        break;
      default:
        break;
    }
  }

  private void handleFirstCountDown(QuizSession quizSession, String token) {
    quizSession.setState("quiz");
    sendQuizUpdate(quizSession, token);
  }

  private void handleNext(QuizSession quizSession, QuizMessage message) throws Exception {
    Claims claims = jwtUtil.extractClaims(message.getUserToken());
    if (claims.getSubject().equals(quizSession.getLeaderUsername())) {
      switch (quizSession.getState()) {
        case "quiz":
          handleQuizState(quizSession);
          break;

        case "score":
          quizSession.setState("quiz");
          quizSession.setCurrentQuestionIndex(quizSession.getCurrentQuestionIndex() + 1);
          break;

        default:
          quizSession.setState("quiz");
          break;
      }
      sendQuizUpdate(quizSession, message.getToken());
    }
  }

  private void handleAnswer(QuizSession quizSession, QuizMessage message) throws Exception {
    Claims claims = jwtUtil.extractClaims(message.getUserToken());
    String username = claims.getSubject();
    String answer = message.getMessage().get("answer").toString();
    Long answerId = Long.parseLong(message.getMessage().get("answerId").toString());

    quizSession.getPlayers().forEach(player -> {
      if (player.getUsername().equals(username)
          && player.getAnswers().size() == quizSession.getCurrentQuestionIndex()) {
        player.getAnswers()
            .add(quizSession.getCurrentQuestionIndex(), new QuizAnswer(answer, answerId));
      }
    });

    if (isAllPlayersAnswered(quizSession)) {
      calculateScore(quizSession);
      if (quizSession.getCurrentQuestionIndex() == quizSession.getAmountOfQuestions() - 1) {
        quizSession.setState("end");
        handleEnd(quizSession);
      } else {
        quizSession.setState("score");
      }
      sendQuizUpdate(quizSession, message.getToken());
    }
  }

  private void handleQuizState(QuizSession quizSession) throws Exception {
    int current = quizSession.getCurrentQuestionIndex();
    int amount = quizSession.getAmountOfQuestions() - 1;
    if (current == amount) {
      quizSession.setState("end");
      handleEnd(quizSession);
    } else {
      calculateScore(quizSession);
      quizSession.setState("score");
    }
  }

  private boolean isAllPlayersAnswered(QuizSession quizSession) {
    long answers = quizSession.getPlayers().stream()
        .filter(player -> player.getAnswers().size() == (quizSession.getCurrentQuestionIndex() + 1))
        .count();
    return answers == quizSession.getPlayers().size();
  }

  private void sendQuizUpdate(QuizSession quizSession, String token) {
    messagingTemplate.convertAndSend("/topic/quiz/game/session/" + token,
        getQuizDetailsFromSessionQuestion(quizSession, quizSession.getCurrentQuestionIndex()));
  }

  private Map<String, Object> getQuizDetailsFromSessionNoQuestions(QuizSession quizSession) {
    Map<String, Object> quizDetails = new HashMap<>();
    quizDetails.put("leaderUsername", quizSession.getLeaderUsername());
    quizDetails.put("players", quizSession.getPlayers());
    quizDetails.put("message", quizSession.getMessage());
    quizDetails.put("token", quizSession.getToken());
    quizDetails.put("isStarted", quizSession.isStarted());
    quizDetails.put("amountOfQuestions", quizSession.getAmountOfQuestions());
    quizDetails.put("state", quizSession.getState());

    Map<String, Object> quiz = new HashMap<>();
    quiz.put("id", quizSession.getQuiz().getId());
    quiz.put("title", quizSession.getQuiz().getTitle());
    quiz.put("description", quizSession.getQuiz().getDescription());
    quiz.put("thumbnail", quizSession.getQuiz().getThumbnail());
    quiz.put("timer", quizSession.getQuiz().getTimer());
    quiz.put("username", quizSession.getQuiz().getUsername());

    quizDetails.put("quiz", quiz);
    return quizDetails;
  }

  private Map<String, Object> getQuizDetailsFromSessionQuestion(QuizSession quizSession,
      int questionIndex) {
    Map<String, Object> quizDetails = new HashMap<>();
    quizDetails.put("leaderUsername", quizSession.getLeaderUsername());
    quizDetails.put("players", quizSession.getPlayers());
    quizDetails.put("message", quizSession.getMessage());
    quizDetails.put("token", quizSession.getToken());
    quizDetails.put("isStarted", quizSession.isStarted());
    quizDetails.put("amountOfQuestions", quizSession.getAmountOfQuestions());
    quizDetails.put("state", quizSession.getState());

    Map<String, Object> quiz = new HashMap<>();
    quiz.put("id", quizSession.getQuiz().getId());
    quiz.put("title", quizSession.getQuiz().getTitle());
    quiz.put("description", quizSession.getQuiz().getDescription());
    quiz.put("thumbnail", quizSession.getQuiz().getThumbnail());
    quiz.put("timer", quizSession.getQuiz().getTimer());
    quiz.put("username", quizSession.getQuiz().getUsername());

    quizDetails.put("quiz", quiz);

    QuizQuestionDto quizQuestion = quizSession.getQuiz().getQuizQuestions().get(questionIndex);

    Collections.shuffle(quizQuestion.getQuizOptions());

    Map<String, Object> quizQuestions = new HashMap<>();
    quizQuestions.put("questions", quizQuestion);

    quizDetails.put("quizQuestions", quizQuestions);
    return quizDetails;
  }

  private void calculateScore(QuizSession session) {

    for (QuizPlayer qp : session.getPlayers()) {
      int score = 0;
      for (int i = 0; i < qp.getAnswers().size(); i++) {
        Long questionId = session.getQuiz().getQuizQuestions().get(i).getId();
        Long optionId = qp.getAnswers().get(i).getId();
        if (quizQuestionRepo.checkIfCorrectAnswer(questionId, optionId).get()) {
          score++;
        }
      }
      qp.setScore(score);
    }

  }

  private void handleEnd(QuizSession session) {
    quizSessionManager.deleteQuizSession(session.getToken());
  }
}
