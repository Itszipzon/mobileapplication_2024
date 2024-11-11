package no.itszipzon.tables;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * When a user played a quiz against other users.
 */
@Entity
@Table(name = "quizSession")
public class QuizSessionTable {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long quizSessionId;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "userId", referencedColumnName = "userId")
  @JsonBackReference
  private User user;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizId", referencedColumnName = "quizId")
  @JsonBackReference
  private QuizSessionManagerTable quizManager;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizAnswerId", referencedColumnName = "quizAnswerId")
  @JsonBackReference
  private QuizAnswer quizAnswer;


  public Long getQuizSessionId() {
    return quizSessionId;
  }

  public void setQuizSessionId(Long quizSessionId) {
    this.quizSessionId = quizSessionId;
  }

  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public QuizSessionManagerTable getQuizManager() {
    return quizManager;
  }

  public void setQuizManager(QuizSessionManagerTable quizManager) {
    this.quizManager = quizManager;
  }
  
  public QuizAnswer getQuizAnswer() {
    return quizAnswer;
  }

  public void setQuizAnswer(QuizAnswer quizAnswer) {
    this.quizAnswer = quizAnswer;
  }

}
