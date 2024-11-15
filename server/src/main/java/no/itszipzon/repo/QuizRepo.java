package no.itszipzon.repo;

import java.util.List;
import java.util.Optional;
import no.itszipzon.dto.QuizDto;
import no.itszipzon.tables.Quiz;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * QuizRepo.
 */
public interface QuizRepo extends JpaRepository<Quiz, Long> {
  @EntityGraph(attributePaths = { "quizQuestions" })
  List<Quiz> findAll();

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q
        JOIN q.user u
      """)
  Optional<List<QuizDto>> findAllByFilter(Pageable pageable);

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      """)
  List<QuizDto> findAllQuizzesSummary();

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE q.quizId = :id
      """)
  Optional<QuizDto> findQuizSummaryById(Long id);

  @EntityGraph(attributePaths = { "quizQuestions", "quizQuestions.quizOptions" })
  Optional<Quiz> findById(Long id);

  @Query("""
      SELECT u.username
      FROM Quiz q JOIN q.user u
      WHERE q.quizId = :id
      """)
  Optional<String> findUsernameFromQuizId(Long id);

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE u.username = :username
      ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findQuizHistoryByUsername(String username, Pageable pageable);

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE u.username = :username
      ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findUsersQuizzes(String username, Pageable pageable);

  @Query("""
      SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q
        JOIN q.user u
        JOIN q.categories qc
      WHERE qc.category.name = :category
        ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findQuizzesByCategory(String category, Pageable pageable);

  @Query("""
          SELECT q.quizId AS id,
                 q.title AS title,
                 q.description AS description,
                 q.thumbnail AS thumbnail,
                 q.timer AS timer,
                 u.username AS username,
                 q.createdAt AS createdAt,
                 u.profilePicture AS profile_picture,
                 COUNT(qa.quizAttemptId) AS attempts
          FROM Quiz q
          JOIN q.user u
          LEFT JOIN QuizAttempt qa ON q.quizId = qa.quiz.quizId
          GROUP BY q.quizId, u.username, u.profilePicture
          ORDER BY COUNT(qa.quizAttemptId) DESC
          LIMIT 10
      """)
  List<Object[]> findTop10PopularQuizzes();

}
