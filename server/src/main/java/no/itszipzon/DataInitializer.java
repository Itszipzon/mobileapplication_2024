package no.itszipzon;

import java.util.List;
import no.itszipzon.repo.CategoryRepo;
import no.itszipzon.repo.LevelRepo;
import no.itszipzon.tables.Category;
import no.itszipzon.tables.Level;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * DataInitializer.
 */
@Component
public class DataInitializer implements CommandLineRunner {
  @Autowired
  private CategoryRepo categoryRepo;
  @Autowired
  private LevelRepo levelRepo;

  @Override
  public void run(String... args) throws Exception {
    // Add code to run when the application starts
    createCategories();
    createLevels();
  }

  private void createCategories() {
    List<Category> existing = categoryRepo.findAll();
    List<String> categories = List.of("General Knowledge", "Science", "History", "Geography", "Art",
        "Sports", "Music", "Movies", "Literature", "Technology", "Nature", "Food & Drink",
        "Animals", "Mythology", "Politics", "Celebrities", "Vehicles", "Comics", "Anime",
        "Cartoons", "Video Games", "Board Games", "Fashion", "Gardening", "Health", "Sci-Fi",
        "Pop Culture", "Mathematics", "Language", "Religion", "Space", "Psychology", "Philosophy",
        "Society", "Business", "Economics", "Education");
    for (String category : categories) {
      if (existing.stream().noneMatch(c -> c.getName().equals(category))) {
        Category newCategory = new Category();
        newCategory.setName(category);
        categoryRepo.save(newCategory);
      }
    }
  }

  private void createLevels() {
/*     List<Level> existing = levelRepo.findAll();
    List<Level> levels = List.of(
      new Level(1, 250),
      new Level(2, 500),
      new Level(3, 1000),
      new Level(4, 2000),
      new Level(5, 4000),
      new Level(6, 8000),
      new Level(7, 16000),
      new Level(8, 32000),
      new Level(9, 64000),
      new Level(10, 128000));

    for (Level level : levels) {
      if (existing.stream()
          .noneMatch(l -> l.getLevel() == level.getLevel() && l.getXp() == level.getXp())) {
        levelRepo.save(level);
      }
    } */
  }
}
