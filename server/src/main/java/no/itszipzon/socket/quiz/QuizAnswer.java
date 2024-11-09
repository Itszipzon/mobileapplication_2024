package no.itszipzon.socket.quiz;

/**
 * A class representing a quiz answer.
 */
public class QuizAnswer {
  
  private Long id;
  private String answer;

  public QuizAnswer() {
  }

  /**
   * Constructor for a quiz answer.
   *
   * @param id The id of the question.
   * @param answer The answer to the question.
   */
  public QuizAnswer(String answer, Long id) {
    this.answer = answer;
    this.id = id;
  }

  public String getAnswer() {
    return answer;
  }

  public void setAnswer(String answer) {
    this.answer = answer;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

}
