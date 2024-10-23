package no.itszipzon.api;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import no.itszipzon.Logger;
import no.itszipzon.Tools;
import no.itszipzon.config.SessionManager;
import no.itszipzon.repo.UserRepo;
import no.itszipzon.tables.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * UserApi.
 */
@RestController
@RequestMapping("api/user")
public class UserApi {

  @Autowired
  private SessionManager sessionManager;

  @Autowired
  private UserRepo userRepo;

  /**
   * Get user.
   *
   * @param authorizationHeader User token.
   * @return User.
   */
  @GetMapping()
  public ResponseEntity<Map<String, Object>> getUser(
      @RequestHeader("Authorization") String authorizationHeader) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);

    if (!sessionManager.hasSession(token)) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    User user = sessionManager.getUser(token);

    Map<String, Object> map = new HashMap<>();
    map.put("id", user.getId());
    map.put("username", user.getUsername());
    map.put("email", user.getEmail());
    map.put("role", user.getRole());
    map.put("created", user.getCreatedAt());
    map.put("updated", user.getUpdatedAt());
    map.put("pfp", user.getProfilePicture());

    Logger.log("User " + user.getUsername() + " requested their own information");
    return new ResponseEntity<>(map, HttpStatus.OK);
  }

  /**
   * Check if user is in session.
   *
   * @param authorizationHeader Authorization header.
   * @return User.
   */
  @GetMapping("/insession")
  public ResponseEntity<Boolean> userInSession(
      @RequestHeader("Authorization") String authorizationHeader) {
    if (authorizationHeader == null
        || !authorizationHeader.startsWith("Bearer ")
        || authorizationHeader.length() < 7) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    return new ResponseEntity<>(sessionManager.hasSession(authorizationHeader.substring(7)),
        HttpStatus.OK);
  }

  @GetMapping("/usernameexists/{username}")
  public ResponseEntity<Boolean> usernameExists(@PathVariable String username) {
    return new ResponseEntity<>(userRepo.findUserByUsername(username).isPresent(), HttpStatus.OK);
  }

  /**
   * Check if user is admin.
   *
   * @param authorizationHeader User token.
   * @return Boolean.
   */
  @GetMapping("/isadmin")
  public ResponseEntity<Boolean> isAdmin(
      @RequestHeader("Authorization") String authorizationHeader) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);

    if (!sessionManager.hasSession(token)) {
      return new ResponseEntity<>(false, HttpStatus.UNAUTHORIZED);
    }
    Logger.info("Checking if " + sessionManager.getUser(token).getUsername() + " is admin");
    return new ResponseEntity<>(sessionManager.getUser(token).getRole().equals("admin"),
        HttpStatus.OK);
  }

  /**
   * Registers a new user.
   *
   * @param values User values to register.
   * @return token.
   */
  @PostMapping("/register")
  public ResponseEntity<String> register(@RequestBody Map<String, String> values) {

    if (!values.get("email").matches(".*@.*\\..*")) {
      return new ResponseEntity<>("Invalid email", HttpStatus.BAD_REQUEST);
    }

    if (values.get("username") == null || values.get("username").isEmpty()) {
      return new ResponseEntity<>("Username is required", HttpStatus.BAD_REQUEST);
    }

    if (values.get("username") == null || values.get("username").isEmpty()) {
      return new ResponseEntity<>("Password is required", HttpStatus.BAD_REQUEST);
    }

    if (!values.get("username").matches("^(?!.*\\.{2})(?!.*\\.$)[a-zA-Z0-9._]{1,30}$")
        || values.get("username").contains(" ")) {
      return new ResponseEntity<>("Invalid username", HttpStatus.BAD_REQUEST);
    }

    if (values.get("password").length() < 8) {
      return new ResponseEntity<>("Password must be at least 8 characters", HttpStatus.BAD_REQUEST);
    }

    if (!Boolean.parseBoolean(values.get("terms"))) {
      return new ResponseEntity<>("You must accept the terms", HttpStatus.BAD_REQUEST);
    }

    if (!values.get("password").equals(values.get("confirmPassword"))) {
      return new ResponseEntity<>("Passwords does not match", HttpStatus.BAD_REQUEST);
    }

    try {
      User user = new User();
      user.setUsername(values.get("username"));
      user.setEmail(values.get("email"));
      user.setTerms(LocalDateTime.now());
      user.setPassword(sessionManager.encryptPassword(values.get("password")));
      userRepo.save(user);

      Logger.log("User " + user.getUsername() + " registered");
      return new ResponseEntity<>("Account registered", HttpStatus.OK);
    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<>("Could not register user", HttpStatus.INTERNAL_SERVER_ERROR);
    }

  }

  /**
   * Login.
   *
   * @param values username or email and password.
   * @return Token.
   */
  @PostMapping("/login")
  public ResponseEntity<String> login(@RequestBody Map<String, String> values) {

    Optional<User> loggedInUser = userRepo.findUserByUsernameOrEmail(values.get("user"));

    if (loggedInUser.isEmpty()) {
      return new ResponseEntity<>("Username, email or password is not correct",
          HttpStatus.UNAUTHORIZED);
    }

    if (loggedInUser.get().getBanned() != null
        && loggedInUser.get().getBanned().isAfter(LocalDateTime.now())) {
      return new ResponseEntity<>("User is banned", HttpStatus.NOT_ACCEPTABLE);
    }

    if (sessionManager.checkPassword(values.get("password"), loggedInUser.get().getPassword())) {

      User neededValuesUser = new User();
      neededValuesUser.setId(loggedInUser.get().getId());
      neededValuesUser.setUsername(loggedInUser.get().getUsername());
      neededValuesUser.setEmail(loggedInUser.get().getEmail());
      neededValuesUser.setProfilePicture(loggedInUser.get().getProfilePicture());
      neededValuesUser.setRole(loggedInUser.get().getRole());
      neededValuesUser.setCreatedAt(loggedInUser.get().getCreatedAt());
      neededValuesUser.setUpdatedAt(loggedInUser.get().getUpdatedAt());

      String token = Tools.generateToken(sessionManager.getSessions());

      sessionManager.addSession(token, neededValuesUser);

      loggedInUser.get().setLastLoggedIn(LocalDateTime.now());
      userRepo.save(loggedInUser.get());

      Logger.log("User " + loggedInUser.get().getUsername() + " logged in");
      return new ResponseEntity<>(token, HttpStatus.OK);
    } else {
      return new ResponseEntity<>("Username or password is not correct", HttpStatus.UNAUTHORIZED);
    }
  }

  /**
   * Logout.
   *
   * @param token User token.
   * @return Response.
   */
  @PostMapping("/logout")
  public ResponseEntity<String> logout(@RequestBody String token) {
    token = token.replace("=", "");
    System.out.println("Logging out");
    if (sessionManager.hasSession(token)) {
      Logger.log("User " + sessionManager.getUser(token).getUsername() + " logged out");
      sessionManager.removeSession(token);
      return new ResponseEntity<>("Logged out", HttpStatus.OK);
    } else {
      return new ResponseEntity<>("Invalid session", HttpStatus.UNAUTHORIZED);
    }
  }

  /**
   * Change password.
   *
   * @param map User information.
   * @return Response.
   */
  @PostMapping("/changepassword")
  public ResponseEntity<String> changePassword(@RequestBody Map<String, String> map) {
    String token = map.get("token");

    if (!sessionManager.hasSession(token)) {
      return new ResponseEntity<>("Invalid session", HttpStatus.UNAUTHORIZED);
    }

    System.out.println(map.toString());

    String oldPassword = map.get("oldPassword");

    User user = sessionManager.getUser(token);

    Optional<User> userFromDb = userRepo.findUserByUsername(user.getUsername());

    if (userFromDb.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }

    if (!sessionManager.checkPassword(oldPassword, userFromDb.get().getPassword())) {
      return new ResponseEntity<>("Old password is not correct", HttpStatus.BAD_REQUEST);
    }

    String newPassword = map.get("newPassword");
    String repeatNewPassword = map.get("repeatNewPassword");

    if (!newPassword.equals(repeatNewPassword)) {
      return new ResponseEntity<>("Passwords do not match", HttpStatus.BAD_REQUEST);
    }

    user.setPassword(sessionManager.encryptPassword(newPassword));
    userRepo.save(user);
    Logger.info("User " + user.getUsername() + " changed password");
    return new ResponseEntity<>("Password changed", HttpStatus.OK);
  }

  /**
   * Ban user.
   *
   * @param entity User information.
   * @return Response.
   */
  @PostMapping("/ban")
  public ResponseEntity<Boolean> banUser(@RequestBody HashMap<String, String> entity) {

    String adminUid = UUID.fromString(entity.get("uid")).toString();

    if (!sessionManager.getUser(adminUid).getRole().equalsIgnoreCase("admin")) {
      return new ResponseEntity<Boolean>(false, HttpStatus.UNAUTHORIZED);
    }

    User bannedUser = sessionManager.getUser(entity.get("bannedUser"));
    LocalDateTime bannedTo = LocalDateTime.parse(entity.get("bannedTo"));

    Optional<User> user = userRepo.findUserByUsername(bannedUser.getUsername());
    user.get().setBanned(bannedTo);
    userRepo.save(user.get());
    sessionManager.terminateSessions(user.get());
    Logger.info("User " + bannedUser.getUsername()
        + " was banned by " + sessionManager.getUser(adminUid).getUsername());
    return new ResponseEntity<>(true, HttpStatus.OK);
  }

  /**
   * postProfilePicture.
   *
   * @return ResponseEntity
   */
  @PostMapping("/pfp")
  public ResponseEntity<String> postProfilePicture(
      @RequestHeader("Authorization") String authorizationHeader,
      @RequestParam("image") MultipartFile image) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);

    if (!sessionManager.hasSession(token)) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    User user = sessionManager.getUser(token);

    try {

      if (image.isEmpty()) {
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
      }

      if (!image.getContentType().equals("image/png")
          && !image.getContentType().equals("image/jpeg")
          && !image.getContentType().equals("image/gif")) {
        return new ResponseEntity<>("Invalid image type", HttpStatus.BAD_REQUEST);
      }

      if (image.getSize() > 4 * 1024 * 1024) {
        return new ResponseEntity<>("File too big", HttpStatus.BAD_REQUEST);
      }

      String pfpName = Tools.addImage(user.getUsername(), image, "pfp");

      if (pfpName.isEmpty()) {
        return new ResponseEntity<>("Could not update image", HttpStatus.INTERNAL_SERVER_ERROR);
      }

      User userFromDb = userRepo.findUserByUsername(user.getUsername()).get();

      userFromDb.setProfilePicture(pfpName);

      for (User u : sessionManager.getSessions().values()) {
        if (u.getUsername().equals(user.getUsername())) {
          u.setProfilePicture(pfpName);
        }
      }

      userRepo.save(userFromDb);
      return new ResponseEntity<>("Image updated", HttpStatus.OK);
    } catch (Exception e) {
      e.printStackTrace();
      Logger.error(e.getMessage());
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Update user.
   *
   * @param user User.
   * @return Response.
   */
  @PutMapping("/update")
  public ResponseEntity<String> updateUser(
      @RequestBody Map<String, String> user,
      @RequestHeader("Authorization") String authorizationHeader) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);

    if (!sessionManager.hasSession(token)) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    User sessionUser = sessionManager.getUser(token);

    String mapEmail = user.get("email");
    String mapUsername = user.get("username");
    String mapNewPassword = user.get("newPassword");

    if (mapUsername.equalsIgnoreCase(sessionUser.getUsername())
        && mapEmail.equalsIgnoreCase(sessionUser.getEmail())
        && mapUsername.equalsIgnoreCase(sessionUser.getUsername())
        && mapNewPassword.isEmpty()) {
      return new ResponseEntity<>("No changes", HttpStatus.BAD_REQUEST);
    }

    if (mapNewPassword.isEmpty() && mapNewPassword.length() < 8) {
      return new ResponseEntity<>("New password is required", HttpStatus.BAD_REQUEST);
    }

    Optional<User> userFromDb = userRepo.findUserByUsername(mapUsername);

    if (userFromDb.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }

    User userToUpdate = userFromDb.get();

    String oldPassword = user.get("oldPassword");

    if (!sessionManager.checkPassword(oldPassword, userToUpdate.getPassword())) {
      return new ResponseEntity<>("Current password is not correct", HttpStatus.BAD_REQUEST);
    }

    if (!mapUsername.isEmpty() && !mapUsername.equalsIgnoreCase(sessionUser.getUsername())) {

      if (!mapUsername.isEmpty()
          && !mapUsername.matches("^(?!.*\\.{2})(?!.*\\.$)[a-zA-Z0-9._]{1,30}$")
          || mapUsername.contains(" ")) {
        return new ResponseEntity<>("Invalid username", HttpStatus.BAD_REQUEST);
      }
      userToUpdate.setUsername(mapUsername);
    }

    if (!mapNewPassword.isEmpty() && mapNewPassword.length() >= 8) {
      userToUpdate.setPassword(sessionManager.encryptPassword(mapNewPassword));
    }

    if (!mapEmail.isEmpty() && !mapEmail.equalsIgnoreCase(sessionUser.getEmail())) {
      userToUpdate.setEmail(mapEmail);
    }

    for (User u : sessionManager.getSessions().values()) {
      if (u.getUsername().equals(sessionUser.getUsername())) {
        if (!mapEmail.isEmpty()) {
          u.setEmail(userToUpdate.getEmail());
        }
        if (!mapUsername.isEmpty()) {
          u.setUsername(userToUpdate.getUsername());
        }
      }
    }

    userRepo.save(userToUpdate);

    return new ResponseEntity<>("User updated", HttpStatus.OK);
  }
}
