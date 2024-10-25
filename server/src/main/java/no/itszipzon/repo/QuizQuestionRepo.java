package no.itszipzon.repo;

import no.itszipzon.tables.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * QuizQuestionRepo.
 */
public interface QuizQuestionRepo extends JpaRepository<QuizQuestion, Long> {

}
