package no.itszipzon.repo;

import java.util.Optional;
import no.itszipzon.tables.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

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
    Optional<Boolean> checkIfCorrectAnswer(long questionId, long optionId);
}
