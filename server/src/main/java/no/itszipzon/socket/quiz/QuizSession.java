package no.itszipzon.socket.quiz;

import java.util.ArrayList;
import java.util.List;
import no.itszipzon.dto.QuizWithQuestionsDto;

/**
 * A class that represents a quiz session.
 */
public class QuizSession {

  private int quizId;
  private String leaderUsername;
  private List<QuizPlayer> players;
  private QuizWithQuestionsDto quiz;
  private String message;
  private String token;

  public QuizSession() {

  }

  /**
   * Constructor for a quiz session.
   *
   * @param leaderUsername The username of the leader.
   * @param quizId         The ID of the quiz.
   */
  public QuizSession(String leaderUsername, int quizId) {
    this.leaderUsername = leaderUsername;
    this.quizId = quizId;
    this.players = new ArrayList<>();
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

  public List<QuizPlayer> getPlayers() {
    return players;
  }

  public void setPlayerUsernames(List<QuizPlayer> players) {
    this.players = players;
  }

  public void addPlayer(QuizPlayer players) {
    this.players.add(players);
  }

  public void addPlayer(String playerName, Long id) {
    this.players.add(new QuizPlayer(playerName, id));
  }

  public void removePlayer(QuizPlayer player) {
    this.players.remove(player);
  }

  /**
   * Adds a player to the quiz session.
   *
   * @param playerName The username of the player.
   */
  public void removePlayer(String playerName) {
    players.removeIf(player -> player.getUsername().equals(playerName));
  }

  public QuizWithQuestionsDto getQuiz() {
    return quiz;
  }

  public void setQuiz(QuizWithQuestionsDto quiz) {
    this.quiz = quiz;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

}
