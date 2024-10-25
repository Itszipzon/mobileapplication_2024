package no.itszipzon.repo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import no.itszipzon.dto.QuizDto;
import no.itszipzon.tables.Quiz;

public interface QuizRepo extends JpaRepository<Quiz, Long> {
    @EntityGraph(attributePaths = { "quizQuestions" })
    List<Quiz> findAll();

    @Query("SELECT new no.itszipzon.dto.QuizDto(q.quizId, q.title, q.description, q.thumbnail, q.timer) FROM Quiz q")
    List<QuizDto> findAllQuizzesSummary();

    @EntityGraph(attributePaths = { "quizQuestions", "quizQuestions.quizOptions" })
    Optional<Quiz> findById(Long id);
}
