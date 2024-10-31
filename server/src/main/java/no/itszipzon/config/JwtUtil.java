package no.itszipzon.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import java.security.Key;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import no.itszipzon.tables.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * JwtUtil class for generating JWT tokens.
 */
@Component
public class JwtUtil {

  @Value("${jwt.secret}")
  private String secret;
  private Key secretKey;

  @PostConstruct
  public void init() {
    secretKey = Keys.hmacShaKeyFor(secret.getBytes());
  }

  /**
   * Generates a JWT token for a user.
   *
   * @param user  The user to generate a token for.
   * @param hours The amount of hours the token should be valid for.
   * @return The generated token.
   */
  public String generateToken(User user, long hours) {
    return Jwts.builder()
        .setSubject(user.getUsername())
        .claim("pfp", user.getProfilePicture())
        .claim("email", user.getEmail())
        .claim("role", user.getRole())
        .claim("id", user.getId())
        .claim("created", convertToDate(user.getCreatedAt()))
        .claim("updated", convertToDate(user.getUpdatedAt()))
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * hours))
        .signWith(secretKey, SignatureAlgorithm.HS256)
        .compact();
  }

  /**
   * Extracts the claims from a token.
   *
   * @param token The token to extract claims from.
   * @return The claims.
   */
  public Claims extractClaims(String token) {
    try {
      return Jwts.parserBuilder()
            .setSigningKey(secretKey)
            .build()
            .parseClaimsJws(token)
            .getBody();
    } catch (io.jsonwebtoken.ExpiredJwtException e) {
      return null;
    } catch (io.jsonwebtoken.JwtException e) {
      return null;
    }
  }

  public String extractUsername(String token) {
    return extractClaims(token).getSubject();
  }

  private Date convertToDate(LocalDateTime localDateTime) {
    return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
  }

}
