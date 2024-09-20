package no.itszipzon.config;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import no.itszipzon.tables.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Class for managing user sessions.
 */
@Component
public class SessionManager {

  private Map<String, User> sessions = new ConcurrentHashMap<>();
  private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

  public void addSession(String sessionId, User user) {
    sessions.put(sessionId, user);
  }

  public void removeSession(String sessionId) {
    sessions.remove(sessionId);
  }

  public User getUser(String sessionId) {
    return sessions.get(sessionId);
  }

  public boolean hasSession(String sessionId) {
    return sessions.containsKey(sessionId);
  }

  public void clearSessions() {
    sessions.clear();
  }

  public Map<String, User> getSessions() {
    return sessions;
  }

  public String encryptPassword(String password) {
    return encoder.encode(password);
  }

  public boolean checkPassword(String password, String hashedPassword) {
    return encoder.matches(password, hashedPassword);
  }

  /**
   * Terminate all sessions for a user. Returns true if any sessions were
   * terminated.
   *
   * @param user the user.
   * @return if any sessions were terminated.
   */
  public boolean terminateSessions(User user) {
    return sessions.entrySet().removeIf(entry -> entry.getValue().getId().equals(user.getId()));
  }
}
