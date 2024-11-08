package no.itszipzon.repo;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import no.itszipzon.tables.QuizQuestion;

public interface QuestionRepo extends JpaRepository<QuizQuestion, Long> {
    
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
