package no.itszipzon.repo;

import java.util.List;
import no.itszipzon.tables.QuizOption;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * QuizOptionRepo.
 */
public interface QuizOptionRepo extends JpaRepository<QuizOption, Long> {

  List<QuizOption> findByQuizQuestionQuizQuestionId(Long quizQuestionId);
}
