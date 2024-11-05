package no.itszipzon.socket.quiz;

import java.util.List;

/**
 * A class representing a quiz in session.
 */
public class QuizQuestion {
  
  private String question;
  private List<String> options;

  public QuizQuestion() {
  }

  /**
   * Constructor for a quiz question.
   *
   * @param question The question.
   * @param options  The options.
   */
  public QuizQuestion(String question, List<String> options) {
    this.question = question;
    this.options = options;
  }

  public String getQuestion() {
    return question;
  }

  public void setQuestion(String question) {
    this.question = question;
  }

  public List<String> getOptions() {
    return options;
  }

  public void setOptions(List<String> options) {
    this.options = options;
  }

}
