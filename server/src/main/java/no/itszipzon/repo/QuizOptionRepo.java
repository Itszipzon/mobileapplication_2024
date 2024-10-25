package no.itszipzon.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import no.itszipzon.tables.QuizOption;

public interface QuizOptionRepo extends JpaRepository<QuizOption, Long> {


    List<QuizOption> findByQuizQuestionQuizQuestionId(Long quizQuestionId);
}
