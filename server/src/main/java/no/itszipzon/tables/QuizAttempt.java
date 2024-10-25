package no.itszipzon.tables;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.List;

/**
 * QuizAttempt.
 */
@Entity
@Table(name = "quizAttempt")
public class QuizAttempt {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long quizAttemptId;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "userId", referencedColumnName = "userId")
  @JsonBackReference
  private User user;

  @ManyToOne(cascade = { CascadeType.MERGE, CascadeType.REMOVE })
  @JoinColumn(name = "quizId", referencedColumnName = "quizId")
  @JsonBackReference
  private Quiz quiz;

  @Column(name = "takenAt")
  private LocalDateTime takenAt;

  @OneToMany(mappedBy = "quizAttempt", cascade = CascadeType.ALL)
  @JsonManagedReference
  private List<QuizAnswer> quizAnswers;

  @PrePersist
  protected void onCreate() {
    LocalDateTime now = LocalDateTime.now();
    takenAt = now;
  }
  
  public Long getQuizAttemptId() {
    return quizAttemptId;
  }

  public void setQuizAttemptId(Long quizAttemptId) {
    this.quizAttemptId = quizAttemptId;
  }

  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public Quiz getQuiz() {
    return quiz;
  }

  public void setQuiz(Quiz quiz) {
    this.quiz = quiz;
  }

  public LocalDateTime getTakenAt() {
    return takenAt;
  }

  public void setTakenAt(LocalDateTime takenAt) {
    this.takenAt = takenAt;
  }

}
