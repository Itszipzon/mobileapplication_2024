package no.ntnu.server.repo;

import java.util.List;
import no.ntnu.server.tables.QuizOption;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * QuizOptionRepo.
 */
public interface QuizOptionRepo extends JpaRepository<QuizOption, Long> {

  List<QuizOption> findByQuizQuestionQuizQuestionId(Long quizQuestionId);
}
