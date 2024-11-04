package no.itszipzon.socket.quiz;

import java.util.ArrayList;
import java.util.List;

/**
 * A class representing a quiz player.
 */
public class QuizPlayer {
  
  String username;
  List<QuizAnswer> answers;
  int score;

  public QuizPlayer() {
  }

  /**
   * Constructor for a quiz player.
   *
   * @param username The username of the player.
   */
  public QuizPlayer(String username) {
    this.username = username;
    this.score = 0;
    this.answers = new ArrayList<>();
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public List<QuizAnswer> getAnswers() {
    return answers;
  }

  public void setAnswers(List<QuizAnswer> answers) {
    this.answers = answers;
  }

  public int getScore() {
    return score;
  }

  public void setScore(int score) {
    this.score = score;
  }

}
