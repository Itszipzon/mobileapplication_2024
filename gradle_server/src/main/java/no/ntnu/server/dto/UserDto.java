package no.ntnu.server.dto;

import java.time.LocalDateTime;

/**
 * UserDto.
 */
public class UserDto {
  
  private Long userId;
  private String username;
  private LocalDateTime created;
  private LocalDateTime updated;
  private LocalDateTime banned;


  /**
   * Constructor.
   *
   * @param userId userId
   * @param username username
   */
  public UserDto(Long userId, String username) {
    this.userId = userId;
    this.username = username;
  }

  /**
   * Constructor.
   *
   * @param userId userId
   * @param username username
   * @param banned banned
   */
  public UserDto(
      Long userId,
      String username,
      LocalDateTime banned) {
    this.userId = userId;
    this.username = username;
    this.banned = banned;
  }

  /**
   * Constructor.
   *
   * @param userId userId
   * @param username username
   * @param created created
   * @param updated updated
   * @param banned banned
   */
  public UserDto(
      Long userId,
      String username,
      LocalDateTime created,
      LocalDateTime updated,
      LocalDateTime banned) {
    this.userId = userId;
    this.username = username;
    this.created = created;
    this.updated = updated;
    this.banned = banned;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public LocalDateTime getCreated() {
    return created;
  }

  public void setCreated(LocalDateTime created) {
    this.created = created;
  }

  public LocalDateTime getUpdated() {
    return updated;
  }

  public void setUpdated(LocalDateTime updated) {
    this.updated = updated;
  }

  public LocalDateTime getBanned() {
    return banned;
  }

  public void setBanned(LocalDateTime banned) {
    this.banned = banned;
  }

}
