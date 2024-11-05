package no.itszipzon.socket.quiz;

import io.jsonwebtoken.Claims;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import no.itszipzon.DtoParser;
import no.itszipzon.Tools;
import no.itszipzon.config.JwtUtil;
import no.itszipzon.repo.QuizRepo;
import no.itszipzon.tables.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * A manager that handles quiz sessions.
 */
@Service
public class QuizSessionManager {

  Map<String, QuizSession> quizSessions;

  @Autowired
  QuizRepo quizRepo;

  @Autowired
  JwtUtil jwtUtil;

  public QuizSessionManager() {
    quizSessions = new ConcurrentHashMap<>();
  }

  /**
   * Creates a quiz session.
   *
   * @param message The message containing the quiz ID and the username.
   * @return The token for the quiz session.
   */
  public String createQuizSession(QuizMessage message) {

    Claims claims = jwtUtil.extractClaims(message.getUserToken());

    QuizSession quizSession = new QuizSession(claims.getSubject(), message.getQuizId());
    quizSession.setMessage("create");
    quizSession.addPlayer(new QuizPlayer(claims.getSubject(), claims.get("id", Long.class)));

    Optional<Quiz> quiz = quizRepo.findById((long) message.getQuizId());

    if (quiz.isPresent()) {
      quizSession.setQuiz(DtoParser.mapToQuizWithQuestionsDto(quiz.get(), quizRepo));
    } else {
      return null;
    }

    int idLength = 8;
    String token = Tools.generateToken(idLength);
    while (quizSessions.containsKey(token)) {
      token = Tools.generateToken(idLength);
    }
    quizSessions.put(token, quizSession);
    return token;
  }

  /**
   * Adds a player to a quiz session.
   *
   * @param token     The token for the quiz session.
   * @param userToken The token for the user.
   */
  public void addPlayerToQuizSession(String token, String userToken) {
    QuizSession quizSession = quizSessions.get(token);
    Claims claims = jwtUtil.extractClaims(userToken);
    if (quizSession.getPlayers().stream()
        .anyMatch(p -> p.getUsername().equals(claims.getSubject()))) {
      return;
    }
    QuizPlayer player = new QuizPlayer(claims.getSubject(), claims.get("id", Long.class));
    System.out.println("Adding player: " + player.getUsername() + " with id: " + player.getId());
    quizSession.addPlayer(player);
  }

  public void deleteQuizSession(String token) {
    quizSessions.remove(token);
  }

  public QuizSession getQuizSession(String token) {
    return quizSessions.get(token);
  }

  public boolean quizSessionExists(String token) {
    return quizSessions.containsKey(token);
  }

}
