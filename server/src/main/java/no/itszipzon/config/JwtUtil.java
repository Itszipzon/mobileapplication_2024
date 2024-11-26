package no.itszipzon.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
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
   * @param rememberMe Whether the token should be remembered.
   * @return The generated token.
   */
  public String generateToken(User user, boolean rememberMe) {
    return Jwts.builder()
        .setSubject(user.getUsername())
        .claim("email", user.getEmail())
        .claim("role", user.getRole())
        .claim("id", user.getId())
        .claim("created", convertToDate(user.getCreatedAt()))
        .claim("updated", convertToDate(user.getUpdatedAt()))
        .claim("rememberMe", rememberMe)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60
            * (rememberMe ? 24 * 30 : 24)))
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
    } catch (ExpiredJwtException e) {
      return null;

    } catch (SignatureException e) {
      return null;
      
    } catch (JwtException e) {
      e.printStackTrace();
      return null;
    }
  }

  private Date convertToDate(LocalDateTime localDateTime) {
    return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
  }

}
