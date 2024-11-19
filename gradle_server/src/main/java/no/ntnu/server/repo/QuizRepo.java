package no.ntnu.server.repo;

import java.util.List;
import java.util.Optional;
import no.ntnu.server.dto.QuizDto;
import no.ntnu.server.tables.Quiz;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * QuizRepo.
 */
public interface QuizRepo extends JpaRepository<Quiz, Long> {
  @EntityGraph(attributePaths = { "quizQuestions" })
  List<Quiz> findAll();

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q
        JOIN q.user u
      """)
  Optional<List<QuizDto>> findAllByFilter(Pageable pageable);

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      """)
  List<QuizDto> findAllQuizzesSummary();

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE q.quizId = :id
      """)
  Optional<QuizDto> findQuizSummaryById(@Param("id") Long id);

  @EntityGraph(attributePaths = { "quizQuestions", "quizQuestions.quizOptions" })
  Optional<Quiz> findById(Long id);

  @Query("""
      SELECT u.username
      FROM Quiz q JOIN q.user u
      WHERE q.quizId = :id
      """)
  Optional<String> findUsernameFromQuizId(@Param("id") Long id);

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE u.username = :username
      ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findQuizHistoryByUsername(@Param("username") String username,
      Pageable pageable);

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q JOIN q.user u
      WHERE u.username = :username
      ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findUsersQuizzes(@Param("username") String username, Pageable pageable);

  @Query("""
      SELECT new no.ntnu.server.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer,
                                           u.username, u.profilePicture, q.createdAt)
      FROM Quiz q
        JOIN q.user u
        JOIN q.categories qc
      WHERE qc.category.name = :category
        ORDER BY q.createdAt DESC
      """)
  Optional<List<QuizDto>> findQuizzesByCategory(@Param("category") String category,
      Pageable pageable);

}