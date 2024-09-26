package no.itszipzon;

import java.util.HashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Test.
 */
@RestController
@RequestMapping("/test")
public class Test {

  /**
   * Test.
   *
   * @return the response entity
   */
  @GetMapping()
  public ResponseEntity<Map<String, String>> test() {
    HashMap<String, String> map = new HashMap<>();
    map.put("message", "This is a message sent from the server to the client");
    map.put("from", "Test");

    return new ResponseEntity<>(map, HttpStatus.OK);
  }

  @GetMapping("/bool")
  public ResponseEntity<Boolean> testBool() {
    return new ResponseEntity<>(false, HttpStatus.OK);
  }
  
}
