package no.itszipzon.socket.quiz;

/**
 * A class representing a quiz answer.
 */
public class QuizAnswer {
  
  private String token;
  private String username;
  private String answer;

  public QuizAnswer() {
  }

  /**
   * Constructor for a quiz answer.
   *
   * @param token The token of the quiz session.
   * @param username The username of the player.
   * @param answer The answer to the question.
   */
  public QuizAnswer(String token, String username, String answer) {
    this.token = token;
    this.answer = answer;
    this.username = username;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  public String getAnswer() {
    return answer;
  }

  public void setAnswer(String answer) {
    this.answer = answer;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

}
