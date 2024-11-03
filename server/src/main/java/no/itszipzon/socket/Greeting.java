package no.itszipzon.socket;

/**
 * A message object that carries data from the server to the client.
 */
public class Greeting {

  private String content;

  public Greeting() {
  }

  public Greeting(String content) {
    this.content = content;
  }

  public String getContent() {
    return content;
  }

}
