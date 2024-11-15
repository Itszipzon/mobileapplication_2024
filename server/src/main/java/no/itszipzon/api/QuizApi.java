package no.itszipzon.api;

import io.jsonwebtoken.Claims;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import no.itszipzon.Tools;
import no.itszipzon.config.JwtUtil;
import no.itszipzon.dto.QuizDto;
import no.itszipzon.dto.QuizOptionDto;
import no.itszipzon.dto.QuizQuestionDto;
import no.itszipzon.dto.QuizWithQuestionsDto;
import no.itszipzon.repo.CategoryRepo;
import no.itszipzon.repo.QuizAttemptRepo;
import no.itszipzon.repo.QuizQuestionRepo;
import no.itszipzon.repo.QuizRepo;
import no.itszipzon.tables.Category;
import no.itszipzon.tables.Quiz;
import no.itszipzon.tables.QuizAttempt;
import no.itszipzon.tables.QuizCategory;
import no.itszipzon.tables.QuizOption;
import no.itszipzon.tables.QuizQuestion;
import no.itszipzon.tables.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * QuizApi.
 */
@RestController
@RequestMapping("api/quiz")
public class QuizApi {

  @Autowired
  private QuizRepo quizRepo;

  @Autowired
  private CategoryRepo categoryRepo;

  @Autowired
  private JwtUtil jwtUtil;

  @Autowired
  private QuizQuestionRepo questionRepo;

  @Autowired
  private QuizAttemptRepo quizAttemptRepo;

  /**
   * Get all quizzes.
   *
   * @return quizzes.
   */
  @GetMapping
  @Transactional(readOnly = true)
  public ResponseEntity<List<QuizDto>> getAllQuizzes() {
    return new ResponseEntity<>(
        quizRepo.findAll().stream().map(this::mapToQuizDto).collect(Collectors.toList()),
        HttpStatus.OK);
  }

  /**
   * Get all quizzes with pagination.
   *
   * @param page page.
   * @param size size.
   * @return quizzes.
   */
  @GetMapping("/all/filter/{page}/{size}/{by}/{orientation}")
  public ResponseEntity<List<QuizDto>> getFilteredQuizzes(@PathVariable int page,
      @PathVariable int size, @PathVariable String by, @PathVariable String orientation) {

    Pageable pageable = PageRequest.of(page, size,
        Sort.by(Sort.Direction.fromString(orientation), by));

    List<QuizDto> quizzes = quizRepo.findAllByFilter(pageable).orElse(new ArrayList<>());

    if (quizzes.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    return new ResponseEntity<>(quizzes, HttpStatus.OK);
  }

  /**
   * Get quiz by id.
   *
   * @param id id.
   * @return quiz.
   */
  @GetMapping("/{id}")
  public ResponseEntity<QuizWithQuestionsDto> getQuizById(@PathVariable Long id) {
    Optional<Quiz> quiz = quizRepo.findById(id);

    return quiz.map(value -> ResponseEntity.ok(mapToQuizWithQuestionsDto(value)))
        .orElseGet(() -> ResponseEntity.notFound().build());
  }

  /**
   * Get quiz image.
   *
   * @param id id.
   * @return image.
   */
  @GetMapping("/thumbnail/{id}")
  public ResponseEntity<Resource> getQuizImage(@PathVariable Long id) {
    Optional<QuizDto> quiz = quizRepo.findQuizSummaryById(id);
    String username = quiz.get().getUsername();
    String thumbnail = quiz.get().getThumbnail();

    String imageFolder = "static/images/" + username + "/quiz/";
    Resource resource;
    String filetype;

    resource = new ClassPathResource(imageFolder + thumbnail);
    filetype = thumbnail.substring(thumbnail.lastIndexOf(".") + 1);

    MediaType mediaType = null;

    switch (filetype) {
      case "png":
        mediaType = MediaType.IMAGE_PNG;
        break;
      case "jpg":
        mediaType = MediaType.IMAGE_JPEG;
        break;
      case "jpeg":
        mediaType = MediaType.IMAGE_JPEG;
        break;
      case "gif":
        mediaType = MediaType.IMAGE_GIF;
        break;
      default:
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    return ResponseEntity.ok().contentType(mediaType).body(resource);
  }

  @GetMapping("/categories")
  @Transactional(readOnly = true)
  public ResponseEntity<List<String>> getCategories() {
    return ResponseEntity.ok(categoryRepo.findAllNames());
  }

  /**
   * Get quizzes by category.
   *
   * @param category category.
   * @param page     page.
   * @return quizzes.
   */
  @GetMapping("/category/{category}/{page}")
  public ResponseEntity<List<QuizDto>> getQuizzesByCategory(@PathVariable String category,
      @PathVariable int page) {
    Pageable pageable = PageRequest.of(page, 10); // 10 quizzes per page
    Optional<List<QuizDto>> quizzes = quizRepo.findQuizzesByCategory(category, pageable);
    if (quizzes.isEmpty()) {
      return new ResponseEntity<>(new ArrayList<>(), HttpStatus.OK);
    }
    return new ResponseEntity<>(quizzes.get(), HttpStatus.OK);
  }

  /**
   * Get quizzes by search.
   *
   * @param authorizationHeader authorizationHeader.
   * @return quizzes.
   */
  @GetMapping("/user/self/{page}/{amount}")
  public ResponseEntity<List<QuizDto>> getQuizzesByUser(
      @RequestHeader("Authorization") String authorizationHeader, @PathVariable int page,
      @PathVariable int amount) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);

    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String username = claims.getSubject();
    Pageable pageable = PageRequest.of(page, amount, Sort.by(Sort.Direction.DESC, "createdAt"));
    Optional<List<QuizDto>> optQuizzes = quizRepo.findUsersQuizzes(username, pageable);
    List<QuizDto> quizzes = optQuizzes.orElse(new ArrayList<>());

    return new ResponseEntity<>(quizzes, HttpStatus.OK);
  }

  /**
   * Get quizzes by search.
   *
   * @param username username.
   * @return quizzes.
   */
  @GetMapping("/user/username/{username}/{page}/{amount}")
  public ResponseEntity<List<QuizDto>> getQuizzesByUsername(@PathVariable String username,
      @PathVariable int page, @PathVariable int amount) {
    Pageable pageable = PageRequest.of(page, amount, Sort.by(Sort.Direction.DESC, "createdAt"));
    Optional<List<QuizDto>> optQuizzes = quizRepo.findUsersQuizzes(username, pageable);
    List<QuizDto> quizzes = optQuizzes.orElse(new ArrayList<>());

    return new ResponseEntity<>(quizzes, HttpStatus.OK);
  }

  /**
   * Get quizzes by search.
   *
   * @param authorizationHeader authorizationHeader.
   * @return quizzes.
   */
  @GetMapping("/user/history/{page}/{amount}")
  public ResponseEntity<List<QuizDto>> getQuizzesByUserHistory(
      @RequestHeader("Authorization") String authorizationHeader, @PathVariable int page,
      @PathVariable int amount) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);

    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String username = claims.getSubject();
    Pageable pageable = PageRequest.of(page, amount, Sort.by(Sort.Direction.DESC, "takenAt"));

    Optional<List<QuizDto>> optQuizzes = quizAttemptRepo
        .findQuizzedFromUserHistory(username, pageable);

    List<QuizDto> quizzes = optQuizzes.orElse(new ArrayList<>());

    return new ResponseEntity<>(quizzes, HttpStatus.OK);
  }

  /**
   * Get all questions for a specific quiz by quiz ID.
   *
   * @param quizId The ID of the quiz.
   * @return A list of questions associated with the quiz.
   */
  @GetMapping("/questions/{quizId}")
  public ResponseEntity<List<QuizQuestionDto>> getQuestionsByQuizId(@PathVariable Long quizId) {
    Optional<Quiz> quizOptional = quizRepo.findById(quizId);

    if (quizOptional.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    // Map quiz questions to DTOs
    List<QuizQuestionDto> questionsDto = quizOptional.get().getQuizQuestions().stream()
        .map(this::mapToQuestionDto).collect(Collectors.toList());

    return new ResponseEntity<>(questionsDto, HttpStatus.OK);
  }

  /**
   * Get the 10 most popular quizzes based on the number of attempts.
   *
   * @return List of popular quizzes.
   */
  @GetMapping("/popular")
  @Transactional(readOnly = true)
  public ResponseEntity<List<Map<String, Object>>> getMostPopularQuizzes() {
    // Query to fetch the 10 most popular quizzes by number of attempts
    List<Object[]> popularQuizzes = quizRepo.findTop10PopularQuizzes();

    // Map the results to the desired response format
    List<Map<String, Object>> response = popularQuizzes.stream().map(record -> {
      Map<String, Object> quizMap = new HashMap<>();
      quizMap.put("id", record[0]);
      quizMap.put("title", record[1]);
      quizMap.put("description", record[2]);
      quizMap.put("thumbnail", record[3]);
      quizMap.put("timer", record[4]);
      quizMap.put("username", record[5]);
      quizMap.put("createdAt", record[6]);
      quizMap.put("profile_picture", record[7]);
      return quizMap;
    }).collect(Collectors.toList());

    return new ResponseEntity<>(response, HttpStatus.OK);
  }

  /**
   * Add a new quiz attempt.
   *
   * @param authorizationHeader Authorization token (Bearer token).
   * @param quizId              The ID of the quiz to attempt.
   * @return ResponseEntity indicating success or failure.
   */
  @PostMapping("/attempt/{quizId}")
  @Transactional
  public ResponseEntity<String> addQuizAttempt(
      @RequestHeader("Authorization") String authorizationHeader,
      @PathVariable Long quizId) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>("Unauthorized: Missing or invalid token.", HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);

    if (claims == null) {
      return new ResponseEntity<>("Unauthorized: Invalid token.", HttpStatus.UNAUTHORIZED);
    }

    Long userId = claims.get("id", Long.class);
    String username = claims.getSubject();

    if (userId == null || username == null) {
      return new ResponseEntity<>("Unauthorized: Invalid user data in token.", HttpStatus.UNAUTHORIZED);
    }

    Optional<Quiz> quizOptional = quizRepo.findById(quizId);
    if (quizOptional.isEmpty()) {
      return new ResponseEntity<>("Quiz not found.", HttpStatus.NOT_FOUND);
    }

    Quiz quiz = quizOptional.get();

    QuizAttempt quizAttempt = new QuizAttempt();
    User user = new User();
    user.setId(userId);
    user.setUsername(username);
    quizAttempt.setUser(user);
    quizAttempt.setQuiz(quiz);

    quizAttemptRepo.save(quizAttempt);

    return new ResponseEntity<>("Quiz attempt added successfully.", HttpStatus.CREATED);
  }

  /**
   * Check if the user's selected options are correct.
   *
   * @return A list of correct option IDs.
   */
  @PostMapping("/check-answers")
  public ResponseEntity<Map<String, Object>> checkAnswers(
      @RequestBody Map<String, Object> userAnswer) {

    System.out.println("checking answers");
    System.out.println(userAnswer);

    Claims claims = jwtUtil.extractClaims(userAnswer.get("token").toString());
    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    long quizId;
    try {
      quizId = Long.parseLong(userAnswer.get("quizId").toString());
    } catch (NumberFormatException e) {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    // Retrieve the quiz by ID
    Optional<Quiz> quizOptional = quizRepo.findById(quizId);
    if (quizOptional.isEmpty()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    Map<String, Object> userCorrectAnswers = new HashMap<>();
    userCorrectAnswers.put("username", claims.getSubject());
    userCorrectAnswers.put("userId", claims.get("id"));
    userCorrectAnswers.put("quizId", quizId);

    Object answersObj = userAnswer.get("quizAnswers");
    if (!(answersObj instanceof List)) {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    List<?> answersList = (List<?>) answersObj;
    List<Map<String, Object>> answers = answersList.stream()
        .filter(Map.class::isInstance)
        .map(Map.class::cast)
        .collect(Collectors.toList());

    List<Map<String, Object>> answerCheck = new ArrayList<>();
    for (Map<String, Object> answer : answers) {
      long questionId;
      try {
        questionId = Long.parseLong(answer.get("questionId").toString());
      } catch (NumberFormatException e) {
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
      }

      // Check if answerId is null
      Object answerIdObj = answer.get("answerId");
      Map<String, Object> check = new HashMap<>();
      check.put("questionId", questionId);
      check.put("answerId", answerIdObj);

      if (answerIdObj == null) {
        // If answerId is null, mark as incorrect
        check.put("correct", false);
      } else {
        long answerId;
        try {
          answerId = Long.parseLong(answerIdObj.toString());
        } catch (NumberFormatException e) {
          return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        // Check if the provided answerId is correct
        Optional<Boolean> correctOptional = questionRepo.checkIfCorrectAnswer(questionId, answerId);
        if (correctOptional.isEmpty()) {
          return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        check.put("correct", correctOptional.get());
      }

      answerCheck.add(check);
    }

    userCorrectAnswers.put("checks", answerCheck);

    return ResponseEntity.ok(userCorrectAnswers);
  }

  /**
   * Create quiz.
   *
   * @param quiz quiz.
   * @return If the quiz was created.
   */
  @PostMapping
  @Transactional
  public ResponseEntity<Boolean> createQuiz(@RequestPart("quiz") Map<String, Object> quiz,
      @RequestPart("thumbnail") MultipartFile thumbnail,
      @RequestHeader("Authorization") String authorizationHeader) {

    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    String token = authorizationHeader.substring(7);
    Claims claims = jwtUtil.extractClaims(token);

    if (claims == null) {
      return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }

    User quizUser = new User();
    System.out.println(claims.getSubject() + " Trying to create a quiz");
    quizUser.setId(claims.get("id", Long.class));
    quizUser.setUsername(claims.getSubject());

    String title = quiz.get("title").toString();
    String description = quiz.get("description").toString();

    if (title.isBlank() || description.isBlank()) {
      return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
    }

    int timer = (int) quiz.get("timer");

    if (timer < 0) {
      return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
    }

    Quiz newQuiz = new Quiz();
    newQuiz.setTitle(title);
    newQuiz.setDescription(description);
    newQuiz.setTimer(timer);
    newQuiz.setQuizQuestions(new ArrayList<>());
    newQuiz.setUser(quizUser);

    Object questionsObj = quiz.get("quizQuestions");
    if (!(questionsObj instanceof List)) {
      return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
    }

    List<?> questionsList = (List<?>) questionsObj;
    List<Map<String, Object>> questions = questionsList.stream().filter(Map.class::isInstance)
        .map(Map.class::cast).collect(Collectors.toList());

    for (Map<String, Object> question : questions) {
      String questionText = (String) question.get("question");

      if (questionText.isBlank()) {
        return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
      }

      QuizQuestion quizQuestion = new QuizQuestion();
      quizQuestion.setQuestion(questionText);
      quizQuestion.setQuiz(newQuiz);
      quizQuestion.setQuizOptions(new ArrayList<>());

      Object optionsObj = question.get("quizOptions");
      if (!(optionsObj instanceof List)) {
        return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
      }

      List<?> optionsList = (List<?>) optionsObj;
      List<Map<String, Object>> options = optionsList.stream().filter(Map.class::isInstance)
          .map(Map.class::cast).collect(Collectors.toList());

      if (options.size() < 2) {
        return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
      }

      boolean hasCorrect = false;
      for (Map<String, Object> option : options) {
        String optionText = (String) option.get("option");
        boolean isCorrect = (boolean) option.get("correct");
        QuizOption quizOption = new QuizOption();
        quizOption.setQuizQuestion(quizQuestion);
        quizOption.setCorrect(isCorrect);
        quizOption.setOption(optionText);

        if (isCorrect) {
          hasCorrect = true;
        }

        quizQuestion.getQuizOptions().add(quizOption);
      }

      if (!hasCorrect) {
        return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
      }

      newQuiz.getQuizQuestions().add(quizQuestion);
    }

    Object categoryObj = quiz.get("categories");
    if (categoryObj != null && !(categoryObj instanceof List<?>)) {
      return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
    }

    List<?> categoryList = (List<?>) categoryObj;
    List<String> categories = categoryList.stream().filter(String.class::isInstance)
        .map(String.class::cast).collect(Collectors.toList());

    if (categories.size() > 0) {
      List<Category> quizCategories = categoryRepo.findAll();
      List<QuizCategory> quizCategoryList = new ArrayList<>();
      for (String category : categories) {
        if (!category.isBlank()) {
          QuizCategory newCategory = new QuizCategory();

          if (quizCategories.stream().anyMatch(c -> c.getName().equals(category))) {
            newCategory.setCategory(quizCategories.stream()
                .filter(c -> c.getName().equals(category)).findFirst().get());
            newCategory.setQuiz(newQuiz);
            quizCategoryList.add(newCategory);
          }
        }
      }
      newQuiz.setCategories(quizCategoryList);
    }

    String thumbnailString = Tools.addImage(quizUser.getUsername(), thumbnail, "quiz");

    if (thumbnailString.isBlank()) {
      System.out.println("Thumbnail is blank");
      return new ResponseEntity<>(false, HttpStatus.BAD_REQUEST);
    }

    newQuiz.setThumbnail(thumbnailString);
    quizRepo.save(newQuiz);
    return new ResponseEntity<>(true, HttpStatus.CREATED);
  }

  /**
   * Delete quiz.
   *
   * @param id id.
   * @return If the quiz was deleted.
   */
  @DeleteMapping("/{id}")
  public ResponseEntity<Boolean> deleteQuiz(@PathVariable Long id) {
    if (quizRepo.existsById(id)) {
      quizRepo.deleteById(id);
      return new ResponseEntity<>(true, HttpStatus.CREATED);
    }
    return new ResponseEntity<>(false, HttpStatus.CREATED);
  }

  private QuizDto mapToQuizDto(Quiz quiz) {
    User user = quiz.getUser();

    return new QuizDto(quiz.getQuizId(), quiz.getTitle(), quiz.getDescription(),
        quiz.getThumbnail(), quiz.getTimer(), user.getUsername(), user.getProfilePicture(),
        quiz.getCreatedAt());
  }

  private QuizWithQuestionsDto mapToQuizWithQuestionsDto(Quiz quiz) {
    List<QuizQuestionDto> questionsDto = quiz.getQuizQuestions().stream()
        .map(this::mapToQuestionDto).collect(Collectors.toList());

    return new QuizWithQuestionsDto(quiz.getQuizId(), quiz.getTitle(), quiz.getDescription(),
        quiz.getThumbnail(), quiz.getTimer(), quiz.getCreatedAt(), questionsDto,
        quizRepo.findUsernameFromQuizId(quiz.getQuizId()).get());
  }

  private QuizQuestionDto mapToQuestionDto(QuizQuestion question) {

    List<QuizOptionDto> optionsDto = question.getQuizOptions().stream()
        .map(option -> new QuizOptionDto(option.getQuizOptionId(), option.getOption(),
            option.isCorrect()))
        .collect(Collectors.toList());

    return new QuizQuestionDto(question.getQuizQuestionId(), question.getQuestion(), optionsDto);
  }
}
