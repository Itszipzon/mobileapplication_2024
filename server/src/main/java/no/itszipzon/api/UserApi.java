package no.itszipzon.api;

import io.jsonwebtoken.Claims;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import no.itszipzon.Logger;
import no.itszipzon.Main;
import no.itszipzon.Tools;
import no.itszipzon.config.JwtUtil;
import no.itszipzon.dto.UserDto;
import no.itszipzon.repo.LevelRepo;
import no.itszipzon.repo.UserRepo;
import no.itszipzon.service.EmailService;
import no.itszipzon.tables.Level;
import no.itszipzon.tables.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
  private UserRepo userRepo;
  @Autowired
  private JwtUtil jwtUtil;
  @Autowired
  private EmailService emailService;
  @Autowired
  private LevelRepo levelRepo;

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
    try {
      Claims claims = jwtUtil.extractClaims(token);
      if (claims == null) {
        return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
      }
      Optional<UserDto> user = userRepo.getUserLevelAndXp(claims.getSubject());
      if (user.isEmpty()) {
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
      }
      Optional<Level> level = levelRepo.getLevel(user.get().getLevel() + 1);
      int xpToNextLevel = -1;
      if (level.isPresent()) {
        xpToNextLevel = level.get().getXp();
      }
      Map<String, Object> map = new HashMap<>();
      map.put("username", claims.getSubject());
      map.put("email", claims.get("email", String.class));
      map.put("role", claims.get("role", String.class));
      map.put("created", claims.get("created", Date.class));
      map.put("updated", claims.get("updated", Date.class));
      map.put("pfp", claims.get("profilePicture", String.class));
      map.put("lvl", user.get().getLevel());
      map.put("exp", user.get().getXp());
      map.put("xpToNextLevel", xpToNextLevel);
      Logger.log("User " + claims.getSubject() + " requested their own information");
      return new ResponseEntity<>(map, HttpStatus.OK);
    } catch (Exception e) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
  }

  /**
   * Get user by username.
   *
   * @param username Username.
   * @return User.
   */
  @GetMapping("/haspfp/{username}")
  public ResponseEntity<Boolean> hasProfilePicture(@PathVariable String username) {
    Optional<User> userOpt = userRepo.findUserByUsername(username);
    if (userOpt.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    if (userOpt.get().getProfilePicture() == null) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    return new ResponseEntity<>(true, HttpStatus.OK);
  }

  /**
   * Get users profile picture.
   *
   * @param username Username.
   * @return User.
   */
  @GetMapping("/pfp/{username}")
  public ResponseEntity<Resource> getProfilePicture(@PathVariable String username) {
    Optional<User> userOpt = userRepo.findUserByUsername(username);
    if (userOpt.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    if (userOpt.get().getProfilePicture() == null) {
      Resource resource = new ClassPathResource("static/images/default_pfp.png");
      MediaType mediaType = MediaType.IMAGE_PNG;
      return ResponseEntity.ok().contentType(mediaType).body(resource);
    }
    User user = userOpt.get();
    String imageFolder = "static/images/" + username + "/pfp/";
    Resource resource;
    String filetype;
    resource = new ClassPathResource(imageFolder + user.getProfilePicture());
    filetype = user.getProfilePicture().substring(user.getProfilePicture().lastIndexOf(".") + 1);
    MediaType mediaType = null;
    switch (filetype) {
      case "png":
        mediaType = MediaType.IMAGE_PNG;
        break;
      case "jpg":
        mediaType = MediaType.IMAGE_JPEG;
        break;
      case "jpeg":
        mediaType = MediaType.IMAGE_JPEG;
        break;
      case "gif":
        mediaType = MediaType.IMAGE_GIF;
        break;
      default:
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    return ResponseEntity.ok().contentType(mediaType).body(resource);
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
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    if (!claims.get("role", String.class).equals("admin")) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    return new ResponseEntity<>(true, HttpStatus.OK);
  }

  /**
   * Check if user is in session.
   *
   * @param authorizationHeader User token.
   * @return Boolean.
   */
  @GetMapping("/insession")
  public ResponseEntity<Boolean> inSession(
      @RequestHeader("Authorization") String authorizationHeader) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    Optional<User> user = userRepo.findUserByUsername(claims.getSubject());
    if (user.isEmpty()) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    if (user.get().getBanned() != null && user.get().getBanned().isAfter(LocalDateTime.now())) {
      return new ResponseEntity<>(false, HttpStatus.OK);
    }
    return new ResponseEntity<>(true, HttpStatus.OK);
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
      user.setPassword(Tools.hashPassword(values.get("password")));
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
    if (Tools.matchPasswords(values.get("password"), loggedInUser.get().getPassword())) {
      loggedInUser.get().setLastLoggedIn(LocalDateTime.now());
      userRepo.save(loggedInUser.get());
      Logger.log("User " + loggedInUser.get().getUsername() + " logged in");
      boolean rememberMe = values.get("rememberMe") == null ? false
          : Boolean.parseBoolean(values.get("rememberMe"));
      String token = jwtUtil.generateToken(loggedInUser.get(), rememberMe);
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
    return new ResponseEntity<>("Logged out", HttpStatus.OK);
  }

  /**
   * Change password.
   *
   * @param map User information.
   * @return Response.
   */
  @PostMapping("/changepassword")
  public ResponseEntity<String> changePassword(@RequestBody Map<String, String> map,
      @RequestHeader("Authorization") String authorizationHeader) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    String token = authorizationHeader.substring(7);
    String oldPassword = map.get("oldPassword");
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    String username = claims.getSubject();
    Optional<User> user = userRepo.findUserByUsername(username);
    if (user.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }
    if (!Tools.matchPasswords(oldPassword, user.get().getPassword())) {
      return new ResponseEntity<>("Old password is not correct", HttpStatus.BAD_REQUEST);
    }
    String newPassword = map.get("newPassword");
    String repeatNewPassword = map.get("repeatNewPassword");
    if (!newPassword.equals(repeatNewPassword)) {
      return new ResponseEntity<>("Passwords do not match", HttpStatus.BAD_REQUEST);
    }
    userRepo.save(user.get());
    Logger.info("User " + user.get().getUsername() + " changed password");
    return new ResponseEntity<>("Password changed", HttpStatus.OK);
  }

  /**
   * Ban user.
   *
   * @param entity User information.
   * @return Response.
   */
  @PostMapping("/ban")
  public ResponseEntity<Boolean> banUser(@RequestBody HashMap<String, String> entity,
      @RequestHeader("Authorization") String authorizationHeader) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    if (!claims.get("role", String.class).equals("admin")) {
      return new ResponseEntity<Boolean>(false, HttpStatus.UNAUTHORIZED);
    }
    Optional<User> user = userRepo.findUserByUsername(claims.getSubject());
    if (user.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    User bannedUser = user.get();
    LocalDateTime bannedTo = LocalDateTime.parse(entity.get("bannedTo"));
    user.get().setBanned(bannedTo);
    userRepo.save(user.get());
    Logger.info("User " + bannedUser.getUsername() + " was banned by " + claims.getSubject());
    return new ResponseEntity<>(true, HttpStatus.OK);
  }

  /**
   * postProfilePicture.
   *
   * @return ResponseEntity
   */
  @SuppressWarnings("null")
  @PostMapping("/pfp")
  public ResponseEntity<String> postProfilePicture(
      @RequestHeader("Authorization") String authorizationHeader,
      @RequestParam("image") MultipartFile image) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
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
      String username = claims.getSubject();
      String pfpName = Tools.addImage(username, image, "pfp");
      if (pfpName.isEmpty()) {
        return new ResponseEntity<>("Could not update image", HttpStatus.INTERNAL_SERVER_ERROR);
      }
      User userFromDb = userRepo.findUserByUsername(username).get();
      userFromDb.setProfilePicture(pfpName);
      userRepo.save(userFromDb);
      return new ResponseEntity<>(
          jwtUtil.generateToken(userFromDb, claims.get("rememberMe", Boolean.class)),
          HttpStatus.OK);
    } catch (Exception e) {
      e.printStackTrace();
      Logger.error(e.getMessage());
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Reset password.
   *
   * @param entity User information.
   * @return Response.
   * @throws MessagingException MessagingException.
   * @throws IOException        IOException.
   */
  @PostMapping("/resetpassword")
  public ResponseEntity<String> postMethodName(@RequestBody String entity)
      throws MessagingException, IOException {
    Optional<User> user = userRepo.findUserByUsernameOrEmail(entity);
    if (user.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }
    User userToUpdate = user.get();
    Map<String, String> map = new HashMap<>();
    map.put("EMAIL", userToUpdate.getEmail());
    map.put("NAME", userToUpdate.getUsername());
    map.put("TOKEN", "RANDOM TOKEN");
    map.put("LINK", "Questionairy.com/resetpassword?token=RANDOM TOKEN");
    String path = new Main().getResource("/static/email_html/forgot_password.html").getPath();
    // emailService.sendHtmlEmail(userToUpdate.getEmail(), "TEST", path, map);
    emailService.sendHtmlEmail("rmolande00@gmail.com", "TEST", path, map);
    return new ResponseEntity<>("Email sent", HttpStatus.OK);
  }

  /**
   * Update user.
   *
   * @param requestBody User.
   * @return Response.
   */
  @PutMapping("/update")
  public ResponseEntity<String> updateUser(@RequestBody Map<String, String> requestBody,
      @RequestHeader("Authorization") String authorizationHeader) {
    // Validate the token
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
    }
    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
    }
    String currentUsername = claims.getSubject();

    String newEmail = requestBody.getOrDefault("email", null);
    String newUsername = requestBody.getOrDefault("username", null);
    
    Optional<User> userFromDb = userRepo.findUserByUsername(currentUsername);
    if (userFromDb.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }
    User userToUpdate = userFromDb.get();
    
    if (newEmail != null && !newEmail.isEmpty()) {
      if (!newEmail.matches(".*@.*\\..*")) {
        return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
      }
      userToUpdate.setEmail(newEmail);
    }
    
    if (newUsername != null && !newUsername.isEmpty()) {
      if (!newUsername.matches("^(?!.*\\.{2})(?!.*\\.$)[a-zA-Z0-9._]{1,30}$")
          || newUsername.contains(" ")) {
        return new ResponseEntity<>("Invalid username", HttpStatus.BAD_REQUEST);
      }
      if (userRepo.findUserByUsername(newUsername).isPresent()) {
        return new ResponseEntity<>("Username already exists", HttpStatus.BAD_REQUEST);
      }
      userToUpdate.setUsername(newUsername);
    }

    String oldPassword = requestBody.getOrDefault("oldPassword", null);
    String newPassword = requestBody.getOrDefault("newPassword", null);
    if (oldPassword != null && newPassword != null && !oldPassword.isEmpty()
        && !newPassword.isEmpty()) {
      if (!Tools.matchPasswords(oldPassword, userToUpdate.getPassword())) {
        return new ResponseEntity<>("Current password is incorrect", HttpStatus.BAD_REQUEST);
      }
      if (newPassword.length() < 8) {
        return new ResponseEntity<>("New password must be at least 8 characters long",
            HttpStatus.BAD_REQUEST);
      }
      userToUpdate.setPassword(Tools.hashPassword(newPassword));
    }
    
    userRepo.save(userToUpdate);
    Logger.info("User " + currentUsername + " updated their profile");
    return new ResponseEntity<>("Profile updated successfully", HttpStatus.OK);
  }

  @PutMapping("/update-email")
  public ResponseEntity<String> updateEmail(@RequestBody Map<String, String> requestBody,
      @RequestHeader("Authorization") String authorizationHeader) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
    }
    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);
    if (claims == null) {
      return new ResponseEntity<>("Unauthorized", HttpStatus.UNAUTHORIZED);
    }
    String currentUsername = claims.getSubject();
    // Validate request body
    String newEmail = requestBody.get("newEmail");
    if (newEmail == null || newEmail.isEmpty() || !newEmail.matches(".*@.*\\..*")) {
      return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
    }
    // Find user in the database
    Optional<User> userFromDb = userRepo.findUserByUsername(currentUsername);
    if (userFromDb.isEmpty()) {
      return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
    }
    // Update the email
    User userToUpdate = userFromDb.get();
    userToUpdate.setEmail(newEmail);
    userRepo.save(userToUpdate);
    Logger.info("User " + currentUsername + " updated their email to " + newEmail);
    return new ResponseEntity<>("Email updated successfully", HttpStatus.OK);
  }
}
