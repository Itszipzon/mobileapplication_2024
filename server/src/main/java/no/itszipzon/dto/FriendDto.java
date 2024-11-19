package no.itszipzon.dto;

public class FriendDto {
    private Long friendId;
    private String username;
    private String status;
    private String createdAt;
    private String acceptedAt;
    private String lastLoggedIn;
    private String profilePicture;

    /**
     * Constructor matching the JPQL query parameters.
     */
    public FriendDto(Long friendId, String username, String status, String createdAt, 
    String acceptedAt, String lastLoggedIn, String profilePicture) {
    this.friendId = friendId;
    this.username = username;
    this.status = status;
    this.createdAt = createdAt;
    this.acceptedAt = acceptedAt;
    this.lastLoggedIn = lastLoggedIn;
    this.profilePicture = profilePicture;
}


    // Getters and Setters
    public Long getFriendId() {
        return friendId;
    }

    public void setFriendId(Long friendId) {
        this.friendId = friendId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(String acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public String getLastLoggedIn() {
        return lastLoggedIn;
    }

    public void setLastLoggedIn(String lastLoggedIn) {
        this.lastLoggedIn = lastLoggedIn;
    }
    
    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }
}