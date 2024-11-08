package no.itszipzon.repo;

import java.util.List;
import no.itszipzon.tables.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * CategoryRepo.
 */
public interface CategoryRepo extends JpaRepository<Category, Long> {
  
  @Query("SELECT c.name FROM Category c ORDER BY c.name ASC")
  List<String> findAllNames();
  
}
