package no.itszipzon;

import java.math.BigDecimal;

public class Test {
  
  public static void main(String[] args) {
    BigDecimal price = new BigDecimal("12345.67");

    BigDecimal tax = new BigDecimal("0.07");
    BigDecimal total = price.add(price.multiply(tax));

    System.out.println(total);

  }
}
