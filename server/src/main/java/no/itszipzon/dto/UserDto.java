package no.itszipzon.dto;

/**
 * UserDto.
 */
public class UserDto {
  
  private Long userId;
  private String username;

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

}
