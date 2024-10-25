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
import no.itszipzon.repo.UserRepo;
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

    @Autowired
    private UserRepo userRepo;

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


    @PostMapping
    public ResponseEntity<Boolean> createQuiz(@RequestBody Map<String, Object> quiz) {
        String title = quiz.get("title").toString();
        String description = quiz.get("description").toString();
        String thumbnail = quiz.get("thumbnail").toString();
        int timer = (int) quiz.get("timer");
        Long userId = ((Number) quiz.get("userId")).longValue();
        Quiz newQuiz = new Quiz();
        User quizUser = userRepo.findById(userId).get();
        newQuiz.setTitle(title);
        newQuiz.setDescription(description);
        newQuiz.setThumbnail(thumbnail);
        newQuiz.setTimer(timer);
        newQuiz.setUser(quizUser);
        quizRepo.save(newQuiz);

        List<Map<String, Object>> questions = (List<Map<String, Object>>) quiz.get("quizQuestions");
        for (Map<String, Object> question : questions) {
            String questionText = (String) question.get("question");
            QuizQuestion quizQuestion = new QuizQuestion();
            quizQuestion.setQuestion(questionText);
            quizQuestion.setQuiz(newQuiz);
            quizQuestionRepo.save(quizQuestion);
            List<Map<String, Object>> options = (List<Map<String, Object>>) question.get("quizOptions");
            for (Map<String, Object> option : options) {
                String optionText = (String) option.get("option");
                boolean isCorrect = (boolean) option.get("correct");
                QuizOption quizOption = new QuizOption();
                quizOption.setQuizQuestion(quizQuestion);
                quizOption.setCorrect(isCorrect);
                quizOption.setOption(optionText);
                quizOptionRepo.save(quizOption);
                // Process each option if needed
            }
        }
        return new ResponseEntity<>(true, HttpStatus.CREATED);
    }
    

    // not working :(
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuiz(@PathVariable Long id) {
        if (quizRepo.existsById(id)) {
            quizRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
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
