package no.ntnu.server.repo;

import java.util.List;
import java.util.Optional;
import no.ntnu.server.dto.QuizDto;
import no.ntnu.server.tables.QuizAttempt;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * QuizAttemptRepo.
 */
public interface QuizAttemptRepo extends JpaRepository<QuizAttempt, Long> {

  @Query("""
        SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail,
            q.timer, u.username, u.profilePicture, q.createdAt)
          FROM QuizAttempt qa
          JOIN qa.user qau
          JOIN qa.quiz q
          JOIN q.user u
          WHERE qau.username = :username
      """)
  Optional<List<QuizDto>> findQuizzedFromUserHistory(@Param("username") String username,
      Pageable pageable);

  @Query("""
        SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail,
            q.timer, u.username, u.profilePicture, q.createdAt)
      FROM QuizAttempt qa
      JOIN qa.user qau
      JOIN qa.quiz q
      JOIN q.user u
      GROUP BY q.quizId, u.username, u.profilePicture,
          q.title, q.description, q.thumbnail, q.timer, q.createdAt
      ORDER BY COUNT(q.quizId) DESC
        """)
  Optional<List<QuizDto>> findTopPopularQuizzes(Pageable page);
}
