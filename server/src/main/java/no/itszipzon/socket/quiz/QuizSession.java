package no.itszipzon.socket.quiz;

import java.util.ArrayList;
import java.util.List;
import no.itszipzon.dto.QuizQuestionDto;
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
  private boolean isStarted;
  private int currentQuestionIndex;

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
    this.isStarted = false;
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

  public void setPlayers(List<QuizPlayer> players) {
    this.players = players;
  }

  /**
   * Adds a player to the quiz session.
   *
   * @param player The player.
   */
  public void addPlayer(QuizPlayer player) {
    if (this.players.stream().anyMatch(p -> p.getUsername().equals(player.getUsername()))) {
      return;
    }
    this.players.add(player);
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

  /**
   * Sets the quiz for the quiz session.
   *
   * @param quiz The quiz.
   */
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

  public boolean isStarted() {
    return isStarted;
  }

  public void setStarted(boolean started) {
    isStarted = started;
  }

  public int getCurrentQuestionIndex() {
    return currentQuestionIndex;
  }

  public void setCurrentQuestionIndex(int currentQuestionIndex) {
    this.currentQuestionIndex = currentQuestionIndex;
  }

  public void incrementCurrentQuestionIndex() {
    this.currentQuestionIndex++;
  }

  public QuizQuestionDto getCurrentQuestion() {
    return quiz.getQuizQuestions().get(currentQuestionIndex);
  }

}
