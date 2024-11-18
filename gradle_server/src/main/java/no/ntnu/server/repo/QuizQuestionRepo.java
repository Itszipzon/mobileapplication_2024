package no.ntnu.server.repo;

import java.util.List;
import java.util.Optional;
import no.ntnu.server.tables.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * QuizQuestionRepo.
 */
public interface QuizQuestionRepo extends JpaRepository<QuizQuestion, Long> {

  @Query("""
            SELECT qo.correct
            FROM QuizQuestion qq
            JOIN qq.quizOptions qo
            WHERE
                qq.id = :questionId
            AND
                qo.id = :optionId
            """)
    Optional<Boolean> checkIfCorrectAnswer(@Param("questionId") long questionId,
        @Param("optionId") long optionId);

  @Query("""
            SELECT qo.id
            FROM QuizQuestion qq
            JOIN qq.quizOptions qo
            WHERE
                qq.id = :questionId
            AND
                qo.correct = true
            """)
  Optional<List<Long>> findCorrectAnswers(@Param("questionId") long questionId);
}
