package no.itszipzon.tables;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;

/**
 * Manages all the quizzes played by users against other users.
 */
@Entity
@Table(name = "quizSessionManager")
public class QuizSessionManagerTable {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long quizSessionManagerId;

  @OneToMany(mappedBy = "quizSessionManager")
  private List<QuizSessionTable> quizSessions;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizId", referencedColumnName = "quizId")
  @JsonBackReference
  private Quiz quiz;

  public Long getQuizSessionManagerId() {
    return quizSessionManagerId;
  }

  public void setQuizSessionManagerId(Long quizSessionManagerId) {
    this.quizSessionManagerId = quizSessionManagerId;
  }

  public List<QuizSessionTable> getQuizSessions() {
    return quizSessions;
  }

  public void setQuizSessions(List<QuizSessionTable> quizSessions) {
    this.quizSessions = quizSessions;
  }

  public Quiz getQuiz() {
    return quiz;
  }

  public void setQuiz(Quiz quiz) {
    this.quiz = quiz;
  }

}
