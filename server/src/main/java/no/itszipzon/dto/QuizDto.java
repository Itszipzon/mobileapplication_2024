package no.itszipzon.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDateTime;

/**
 * QuizDto.
 */
public class QuizDto {

  private long id;
  private String title;
  private String description;
  private String thumbnail;
  private Integer timer;

  private String username;

  @JsonProperty("profile_picture")
  private String profilePicture;

  private LocalDateTime createdAt;

  /**
   * Constructor.
   *
   * @param id id.
   * @param title title.
   * @param description description.
   * @param thumbnail thumbnail.
   * @param timer timer.
   * @param username username.
   * @param profilePicture profilePicture.
   * @param createdAt createdAt.
   */
  public QuizDto(long id, String title, String description, String thumbnail, Integer timer,
      String username, String profilePicture, LocalDateTime createdAt) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.thumbnail = thumbnail;
    this.timer = timer;
    this.username = username;
    this.profilePicture = profilePicture;
    this.createdAt = createdAt; // Initialize createdAt
  }

  // Getter and setter for createdAt
  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  // Existing getters and setters

  public String getProfilePicture() {
    return profilePicture;
  }

  public void setProfilePicture(String profilePicture) {
    this.profilePicture = profilePicture;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getThumbnail() {
    return thumbnail;
  }

  public void setThumbnail(String thumbnail) {
    this.thumbnail = thumbnail;
  }

  public Integer getTimer() {
    return timer;
  }

  public void setTimer(Integer timer) {
    this.timer = timer;
  }
}
