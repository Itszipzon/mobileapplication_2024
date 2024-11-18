package no.ntnu.server.repo;

import no.ntnu.server.tables.QuizSessionManagerTable;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * QuizSessionRepo.
 */
public interface QuizSessionRepo extends JpaRepository<QuizSessionManagerTable, Long> {

  
}
