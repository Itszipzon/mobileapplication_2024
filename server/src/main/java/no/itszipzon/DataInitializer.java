package no.itszipzon;

import java.util.List;
import no.itszipzon.repo.CategoryRepo;
import no.itszipzon.tables.Category;
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

  @Override
  public void run(String... args) throws Exception {
    // Add code to run when the application starts
    createCategories();
  }

  private void createCategories() {
    List<Category> existing = categoryRepo.findAll();
    List<String> categories = List.of(
        "General Knowledge",
        "Science",
        "History",
        "Geography",
        "Art",
        "Sports",
        "Music",
        "Movies",
        "Literature",
        "Technology",
        "Nature",
        "Food & Drink",
        "Animals",
        "Mythology",
        "Politics",
        "Celebrities",
        "Vehicles",
        "Comics",
        "Anime",
        "Cartoons",
        "Video Games",
        "Board Games",
        "Fashion",
        "Gardening",
        "Health",
        "Sci-Fi",
        "Pop Culture",
        "Mathematics",
        "Language",
        "Religion",
        "Space",
        "Psychology",
        "Philosophy",
        "Society",
        "Business",
        "Economics",
        "Education"
        );
    
    for (String category : categories) {
      if (existing.stream().noneMatch(c -> c.getName().equals(category))) {
        Category newCategory = new Category();
        newCategory.setName(category);
        categoryRepo.save(newCategory);
      }
    }
  }

}
