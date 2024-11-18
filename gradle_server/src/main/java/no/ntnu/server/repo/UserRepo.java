package no.ntnu.server.repo;

import java.util.List;
import java.util.Optional;
import no.ntnu.server.dto.UserDto;
import no.ntnu.server.tables.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * UserRepo.
 */
public interface UserRepo extends JpaRepository<User, Long> {

  @Query("SELECT u FROM User u WHERE u.username = :username")
  Optional<User> findUserByUsername(String username);

  @Query("SELECT u FROM User u WHERE u.username = :value OR u.email = :value")
  Optional<User> findUserByUsernameOrEmail(String value);

  @Query("""
      SELECT new no.ntnu.server.dto.UserDto(u.userId, u.username)
      FROM User u
      WHERE
        u.username LIKE %:value%
      """)
  Optional<List<UserDto>> searchUsersByUsernameOrDisplayname(String value);

}
