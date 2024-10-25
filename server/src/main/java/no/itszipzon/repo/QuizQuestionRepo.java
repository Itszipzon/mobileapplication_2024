package no.itszipzon.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import no.itszipzon.tables.QuizQuestion;

public interface QuizQuestionRepo extends JpaRepository<QuizQuestion, Long> {


    List<QuizQuestion> findByQuizQuizId(Long quizId);
}
