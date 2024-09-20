package no.itszipzon.dto;

/**
 * UserDto.
 */
public class UserDto {
  
  private Long userId;
  private String username;
  private String displayName;

  /**
   * Constructor.
   *
   * @param userId userId
   * @param username username
   * @param displayName displayName
   */
  public UserDto(Long userId, String username, String displayName) {
    this.userId = userId;
    this.username = username;
    this.displayName = displayName;
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

  public String getDisplayName() {
    return displayName;
  }

  public void setDisplayName(String displayName) {
    this.displayName = displayName;
  }

}
