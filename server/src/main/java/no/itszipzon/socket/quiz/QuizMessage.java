package no.itszipzon.socket.quiz;

/**
 * A message object that carries data from the client to the server.
 */
public class QuizMessage {

  private int quizId;
  private String username;
  private String token;

  public QuizMessage() {
  }

  public QuizMessage(int quizId) {
    this.quizId = quizId;
  }

  public int getQuizId() {
    return quizId;
  }

  public void setQuizId(int quizId) {
    this.quizId = quizId;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }
  
}
