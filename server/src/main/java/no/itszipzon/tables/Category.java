package no.itszipzon.tables;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;

/**
 * Category.
 */
@Entity
@Table(name = "category")
public class Category {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "categoryId")
  private Long categoryId;

  @Column(nullable = false, name = "name")
  private String name;

  @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL)
  @JsonManagedReference
  private List<Quiz> quizes;


  public Long getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(Long categoryId) {
    this.categoryId = categoryId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<Quiz> getQuizes() {
    return quizes;
  }

  public void setQuizes(List<Quiz> quizes) {
    this.quizes = quizes;
  }

}
