package no.itszipzon.repo;

import no.itszipzon.tables.QuizAttempt;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * QuizAttemptRepo.
 */
public interface QuizAttemptRepo extends JpaRepository<QuizAttempt, Long> {
  
}
