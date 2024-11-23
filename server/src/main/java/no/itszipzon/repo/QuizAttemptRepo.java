package no.itszipzon.repo;

import java.util.List;
import java.util.Optional;
import no.itszipzon.dto.QuizDto;
import no.itszipzon.tables.QuizAttempt;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * QuizAttemptRepo.
 */
public interface QuizAttemptRepo extends JpaRepository<QuizAttempt, Long> {
  @Query("""
        SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
          FROM QuizAttempt qa
          JOIN qa.user qau
          JOIN qa.quiz q
          JOIN q.user u
          WHERE qau.username = :username
      """)
  Optional<List<QuizDto>> findQuizzedFromUserHistory(String username, Pageable pageable);

  @Query("""
        SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                       u.username, u.profilePicture, q.createdAt)
      FROM QuizAttempt qa
      JOIN qa.user qau
      JOIN qa.quiz q
      JOIN q.user u
      GROUP BY q.quizId, u.username, u.profilePicture, q.title, q.description,
       q.thumbnail, q.timer, q.createdAt
      ORDER BY COUNT(q.quizId) DESC
        """)
  Optional<List<QuizDto>> findTopPopularQuizzes(Pageable page);

  @Query("""
        SELECT COUNT(qa)
          FROM QuizAttempt qa
          JOIN qa.user qau
          JOIN qa.quiz q
          JOIN q.user u
          WHERE qau.username = :username
          AND q.quizId = :quizId
          AND qa.takenAt >= :startOfLastMonth
          AND qa.takenAt < :startOfThisMonth
      """)
int amountPreviousMonth(
      @Param("username") String username,
      @Param("quizId") Long quizId,
      @Param("startOfLastMonth") java.time.LocalDateTime startOfLastMonth,
      @Param("startOfThisMonth") java.time.LocalDateTime startOfThisMonth
);
}
