package no.itszipzon.repo;

import java.util.List;
import java.util.Optional;
import no.itszipzon.dto.QuizDto;
import no.itszipzon.tables.QuizAttempt;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * QuizAttemptRepo.
 */
public interface QuizAttemptRepo extends JpaRepository<QuizAttempt, Long> {
  
  @Query("""
        SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
          FROM QuizAttempt qa
          JOIN qa.user u
          JOIN qa.quiz q
          WHERE u.username = :username
      """)
  Optional<List<QuizDto>> findQuizzedFromUserHistory(
      String username,
      Pageable pageable);
}