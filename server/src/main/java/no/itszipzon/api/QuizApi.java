package no.itszipzon.api;

import no.itszipzon.config.SessionManager;
import no.itszipzon.dto.QuizDto;
import no.itszipzon.dto.QuizOptionDto;
import no.itszipzon.dto.QuizQuestionDto;
import no.itszipzon.repo.QuizRepo;
import no.itszipzon.repo.QuizQuestionRepo;
import no.itszipzon.repo.QuizOptionRepo;
import no.itszipzon.tables.Quiz;
import no.itszipzon.tables.QuizQuestion;
import no.itszipzon.tables.User;
import no.itszipzon.tables.QuizOption;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("api/quiz")
public class QuizApi {

    @Autowired
    private QuizRepo quizRepo;

    @Autowired
    private QuizQuestionRepo quizQuestionRepo;

    @Autowired
    private QuizOptionRepo quizOptionRepo;

    @Autowired
  private SessionManager sessionManager;

    @GetMapping
    @Transactional(readOnly = true)
    public List<QuizDto> getAllQuizzes() {
        return quizRepo.findAll().stream().map(this::mapToQuizDto).collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<QuizDto> getQuizById(@PathVariable Long id) {
        Optional<Quiz> quiz = quizRepo.findById(id);
        return quiz.map(value -> ResponseEntity.ok(mapToQuizDto(value)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }


    //not working :( 
    @PostMapping
    public ResponseEntity<Boolean> createQuiz(@RequestBody Map<String, Object> quiz) {
        System.out.println(quiz.toString());
        return new ResponseEntity<>(true, HttpStatus.CREATED);
    }
    

    @PutMapping("/{id}")
    public ResponseEntity<QuizDto> updateQuiz(@PathVariable Long id, @RequestBody Quiz updatedQuiz) {
        return quizRepo.findById(id).map(quiz -> {
            quiz.setTitle(updatedQuiz.getTitle());
            quiz.setDescription(updatedQuiz.getDescription());
            quiz.setThumbnail(updatedQuiz.getThumbnail());
            quiz.setTimer(updatedQuiz.getTimer());
            quiz.setUpdatedAt(LocalDateTime.now());
            Quiz savedQuiz = quizRepo.save(quiz);
            return ResponseEntity.ok(mapToQuizDto(savedQuiz));
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuiz(@PathVariable Long id) {
        if (quizRepo.existsById(id)) {
            quizRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/{quizId}/questions")
    public ResponseEntity<QuizQuestionDto> addQuestionToQuiz(@PathVariable Long quizId,
            @RequestBody QuizQuestion question) {
        return quizRepo.findById(quizId).map(quiz -> {
            question.setQuiz(quiz);
            QuizQuestion savedQuestion = quizQuestionRepo.save(question);
            return new ResponseEntity<>(mapToQuestionDto(savedQuestion), HttpStatus.CREATED);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/{quizId}/questions")
    public ResponseEntity<List<QuizQuestionDto>> getQuestionsByQuizId(@PathVariable Long quizId) {
        return quizRepo.findById(quizId)
                .map(quiz -> {
                    List<QuizQuestionDto> questionsDto = quiz.getQuizQuestions().stream()
                            .map(this::mapToQuestionDto)
                            .collect(Collectors.toList());
                    return ResponseEntity.ok(questionsDto);
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/questions/{questionId}/options")
    public ResponseEntity<QuizOptionDto> addOptionToQuestion(@PathVariable Long questionId,
            @RequestBody QuizOption option) {
        return quizQuestionRepo.findById(questionId).map(question -> {
            option.setQuizQuestion(question);
            QuizOption savedOption = quizOptionRepo.save(option);
            return new ResponseEntity<>(
                    new QuizOptionDto(savedOption.getQuizOptionId(), savedOption.getOption(), savedOption.isCorrect()),
                    HttpStatus.CREATED);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/questions/{questionId}/options")
    public ResponseEntity<List<QuizOptionDto>> getOptionsByQuestionId(@PathVariable Long questionId) {
        return quizQuestionRepo.findById(questionId)
                .map(question -> {
                    List<QuizOptionDto> optionsDto = question.getQuizOptions().stream()
                            .map(option -> new QuizOptionDto(option.getQuizOptionId(), option.getOption(),
                                    option.isCorrect()))
                            .collect(Collectors.toList());
                    return ResponseEntity.ok(optionsDto);
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    private QuizDto mapToQuizDto(Quiz quiz) {
        List<QuizQuestionDto> questionsDto = quiz.getQuizQuestions().stream().map(this::mapToQuestionDto)
                .collect(Collectors.toList());
        return new QuizDto(quiz.getQuizId(), quiz.getTitle(), quiz.getDescription(), quiz.getThumbnail(),
                quiz.getTimer(), questionsDto);
    }

    private QuizQuestionDto mapToQuestionDto(QuizQuestion question) {
        List<QuizOptionDto> optionsDto = question.getQuizOptions().stream()
                .map(option -> new QuizOptionDto(option.getQuizOptionId(), option.getOption(), option.isCorrect()))
                .collect(Collectors.toList());
        return new QuizQuestionDto(question.getQuizQuestionId(), question.getQuestion(), optionsDto);
    }
}
