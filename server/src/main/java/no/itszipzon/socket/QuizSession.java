package no.itszipzon.socket;

import java.util.ArrayList;
import java.util.List;
import no.itszipzon.dto.QuizWithQuestionsDto;

/**
 * A class that represents a quiz session.
 */
public class QuizSession {

  private int quizId;
  private String leaderUsername;
  private List<String> playerUsernames;
  private QuizWithQuestionsDto quiz;

  public QuizSession() {

  }

  public QuizSession(String leaderUsername, int quizId) {
    this.leaderUsername = leaderUsername;
    this.quizId = quizId;
  }

  /**
   * Constructor for a quiz session.
   *
   * @param message The message containing the username and quiz ID.
   */
  public QuizSession(QuizMessage message) {
    this.leaderUsername = message.getUsername();
    this.quizId = message.getQuizId();
    this.playerUsernames = new ArrayList<>();
    playerUsernames.add(message.getUsername());
  }

  public int getQuizId() {
    return quizId;
  }

  public void setQuizId(int quizId) {
    this.quizId = quizId;
  }

  public String getLeaderUsername() {
    return leaderUsername;
  }

  public void setLeaderUsername(String leaderUsername) {
    this.leaderUsername = leaderUsername;
  }

  public List<String> getPlayerUsernames() {
    return playerUsernames;
  }

  public void setPlayerUsernames(List<String> playerUsernames) {
    this.playerUsernames = playerUsernames;
  }

  public void addPlayer(String playerUsername) {
    playerUsernames.add(playerUsername);
  }

  public void removePlayer(String playerUsername) {
    playerUsernames.remove(playerUsername);
  }

  public QuizWithQuestionsDto getQuiz() {
    return quiz;
  }

  public void setQuiz(QuizWithQuestionsDto quiz) {
    this.quiz = quiz;
  }
  
}
