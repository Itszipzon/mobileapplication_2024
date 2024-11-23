package no.itszipzon.service;

import java.util.Optional;
import no.itszipzon.repo.LevelRepo;
import no.itszipzon.repo.UserRepo;
import no.itszipzon.tables.Level;
import no.itszipzon.tables.User;
import org.springframework.stereotype.Service;

/**
 * Service for the Level table.
 */
@Service
public class UserService {
  private LevelRepo levelRepo;
  private UserRepo userRepo;

  public UserService(UserRepo userRepo, LevelRepo levelRepo) {
    this.userRepo = userRepo;
    this.levelRepo = levelRepo;
  }

  /**
   * Method to get the level of a user.
   *
   * @param userId id of the user
   * @return the level of the user
   */
  public User addXp(Long userId, int xpGained) {
    Optional<User> userOptional = userRepo.findById(userId);
    if (userOptional.isEmpty()) {
      throw new RuntimeException("User not found");
    }
    User user = userOptional.get();
    int newXp = user.getXp() + xpGained;
    int currentLevel = user.getLevel();
    while (true) {
      Optional<Level> nextLevel = levelRepo.getLevel(currentLevel + 1);
      if (nextLevel.isEmpty() || newXp < nextLevel.get().getXp()) {
        break;
      }
      newXp -= nextLevel.get().getXp();
      currentLevel++;
    }
    user.setXp(newXp);
    user.setLevel(currentLevel);
    return userRepo.save(user);
  }
}
