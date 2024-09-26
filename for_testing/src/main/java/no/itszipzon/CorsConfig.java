package no.itszipzon;

import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * CORS configuration.
 */
@Configuration
@EnableWebMvc
public class CorsConfig implements WebMvcConfigurer  {

  @Override
  public void addCorsMappings(@NonNull CorsRegistry registry) {

    String[] allowedOrigins = {
      "http://localhost:57727",
    };

    registry.addMapping("/test/**")
            .allowedOrigins(allowedOrigins)
            .allowedMethods("GET", "PUT", "DELETE", "POST", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true);
  }
  
}
