package no.ntnu.server;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.SecureRandom;
import java.util.UUID;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.multipart.MultipartFile;

/**
 * Class for tools that are used in the backend.
 */
public class Tools {

  private Tools() {
  }

  public static Dotenv getEnv() {
    return Dotenv.load();
  }

  /**
   * Generates a secure token.
   *
   * @param length The length of the token
   * @return token
   */
  public static String generateToken(int length) {
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    SecureRandom random = new SecureRandom();
    StringBuilder token = new StringBuilder(length);
    for (int i = 0; i < length; i++) {
      token.append(characters.charAt(random.nextInt(characters.length())));
    }
    return token.toString();
  }

  /**
   * Method to get the correct URL.
   *
   * @param url The URL to check
   * @return The correct URL
   */
  public static String getCorrectUrl(String url) {
    if (System.getProperty("os.name").contains("Windows")) {
      url = url.substring(1);
    }
    return url;
  }

  /**
   * Add image to user.
   *
   * @param username username of the user
   * @param image    image to add.
   * @return true if the image was added, false if not.
   */
  public static String addImage(String username, MultipartFile image, String type) {
    String staticLocation = new Main().getResource("/static").getPath();
    if (!Files.exists(Path.of(Tools.getCorrectUrl(staticLocation + "/images")))) {
      try {
        Files.createDirectories(Path.of(Tools.getCorrectUrl(staticLocation + "/images")));
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
    String path = new Main().getResource("/static/images").getPath();
    String pathBefore = new Main().getResource("/static").getPath();

    if (image.isEmpty()) {
      return "";
    }

    path += "/";
    pathBefore += "/../../../src/main/resources/static/images/";

    try {
      byte[] bytes = image.getBytes();
      if (type.equalsIgnoreCase("pfp")) {
        if (!Files.exists(Path.of(Tools.getCorrectUrl(path + username + "/pfp")))) {
          Files.createDirectories((Path.of(Tools.getCorrectUrl(path + username + "/pfp"))));
        }
  
        if (!Files.exists(Path.of(Tools.getCorrectUrl(pathBefore + username + "/pfp")))) {
          Files.createDirectories(Path.of(Tools.getCorrectUrl(pathBefore + username + "/pfp")));
        }
  
        UUID uid = UUID.randomUUID();
        String filename = uid.toString();

        if (image.getContentType().equals("image/png")) {
          filename += ".png";
        } else if (image.getContentType().equals("image/jpeg")) {
          filename += ".jpeg";
        } else if (image.getContentType().equals("image/gif")) {
          filename += ".gif";
        } else {
          return "";
        }

        Path filePath = Path
            .of(Tools
                .getCorrectUrl(path + username + "/pfp/" + filename));
  
        Path filePathBefore = Path
            .of(Tools
                .getCorrectUrl(pathBefore
                + username + "/pfp/" + filename));
  
        Files.write(filePath, bytes);
        Files.write(filePathBefore, bytes);
        return filename;
      } else if (type.equalsIgnoreCase("quiz")) {
        if (!Files.exists(Path.of(Tools.getCorrectUrl(path + username + "/quiz")))) {
          Files.createDirectories((Path.of(Tools.getCorrectUrl(path + username + "/quiz"))));
        }
  
        if (!Files.exists(Path.of(Tools.getCorrectUrl(pathBefore + username + "/quiz")))) {
          Files.createDirectories(Path.of(Tools.getCorrectUrl(pathBefore + username + "/quiz")));
        }
  
        UUID uid = UUID.randomUUID();
        String filename = uid.toString();

        if (image.getContentType().equals("image/png")) {
          filename += ".png";
        } else if (image.getContentType().equals("image/jpeg")) {
          filename += ".jpeg";
        } else if (image.getContentType().equals("image/gif")) {
          filename += ".gif";
        } else {
          return "";
        }

        Path filePath = Path
            .of(Tools
                .getCorrectUrl(path + username + "/quiz/" + filename));
  
        Path filePathBefore = Path
            .of(Tools
                .getCorrectUrl(pathBefore
                + username + "/quiz/" + filename));
  
        Files.write(filePath, bytes);
        Files.write(filePathBefore, bytes);
        return filename;
      } else {
        return "";
      }
    } catch (IOException e) {
      e.printStackTrace();
      return "";
    }
  }

  public static boolean matchPasswords(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  public static String hashPassword(String password) {
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
    return encoder.encode(password);
  }

}