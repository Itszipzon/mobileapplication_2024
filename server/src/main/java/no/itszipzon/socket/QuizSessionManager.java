package no.itszipzon.socket;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import no.itszipzon.DtoParser;
import no.itszipzon.Tools;
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
    QuizSession quizSession = new QuizSession(message);

    Optional<Quiz> quiz = quizRepo.findById((long) message.getQuizId());

    if (quiz.isPresent()) {
      quizSession.setQuiz(DtoParser.mapToQuizWithQuestionsDto(quiz.get(), quizRepo));
    } else {
      return null;
    }

    String token = Tools.generateToken(5);
    quizSessions.put(token, quizSession);
    return token;
  }

  public void addPlayerToQuizSession(String token, String username) {
    QuizSession quizSession = quizSessions.get(token);
    quizSession.addPlayer(username);
  }

  public void removePlayerFromQuizSession(String token, String username) {
    QuizSession quizSession = quizSessions.get(token);
    quizSession.removePlayer(username);
  }

  public void deleteQuizSession(String token) {
    quizSessions.remove(token);
  }
  
}
