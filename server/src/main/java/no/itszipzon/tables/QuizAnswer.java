package no.itszipzon.tables;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Answer to each question in a quiz attempt.
 */
@Entity
@Table(name = "quizAnswer")
public class QuizAnswer {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "quizAnswerId")
  private Long quizAnswerId;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizQuestionId", referencedColumnName = "quizQuestionId")
  @JsonBackReference
  private QuizQuestion quizOption;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizOptionId", referencedColumnName = "quizOptionId")
  @JsonBackReference
  private QuizOption quizQuestion;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizAttemptId", referencedColumnName = "quizAttemptId")
  @JsonBackReference
  private QuizAttempt quizAttempt;

  public Long getQuizAnswerId() {
    return quizAnswerId;
  }

  public void setQuizAnswerId(Long quizAnswerId) {
    this.quizAnswerId = quizAnswerId;
  }

  public QuizQuestion getQuizOption() {
    return quizOption;
  }

  public void setQuizOption(QuizQuestion quizOption) {
    this.quizOption = quizOption;
  }

  public QuizOption getQuizQuestion() {
    return quizQuestion;
  }

  public void setQuizQuestion(QuizOption quizQuestion) {
    this.quizQuestion = quizQuestion;
  }

}
