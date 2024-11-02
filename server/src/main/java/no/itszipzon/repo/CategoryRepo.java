package no.itszipzon.repo;

import no.itszipzon.tables.Category;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * CategoryRepo.
 */
public interface CategoryRepo extends JpaRepository<Category, Long> {
  
  
}
