package no.ntnu.server;

import java.util.List;
import java.util.stream.Collectors;
import no.ntnu.server.dto.QuizDto;
import no.ntnu.server.dto.QuizOptionDto;
import no.ntnu.server.dto.QuizQuestionDto;
import no.ntnu.server.dto.QuizWithQuestionsDto;
import no.ntnu.server.repo.QuizRepo;
import no.ntnu.server.tables.Quiz;
import no.ntnu.server.tables.QuizQuestion;
import no.ntnu.server.tables.User;

/**
 * A class that parses entities to DTOs.
 */
public class DtoParser {

  /**
   * Maps a quiz entity to a quiz DTO.
   *
   * @param quiz The quiz entity.
   * @return The quiz DTO.
   */
  public static QuizDto mapToQuizDto(Quiz quiz) {
    User user = quiz.getUser();

    return new QuizDto(quiz.getQuizId(), quiz.getTitle(), quiz.getDescription(),
        quiz.getThumbnail(), quiz.getTimer(), user.getUsername(), user.getProfilePicture(),
        quiz.getCreatedAt());
  }

  /**
   * Maps a quiz entity to a quiz with questions DTO.
   *
   * @param quiz The quiz entity.
   * @return The quiz with questions DTO.
   */
  public static QuizWithQuestionsDto mapToQuizWithQuestionsDto(Quiz quiz, QuizRepo quizRepo) {
    List<QuizQuestionDto> questionsDto = quiz.getQuizQuestions().stream()
        .map(DtoParser::mapToQuestionDto).collect(Collectors.toList());

    return new QuizWithQuestionsDto(quiz.getQuizId(), quiz.getTitle(), quiz.getDescription(),
        quiz.getThumbnail(), quiz.getTimer(), quiz.getCreatedAt(), questionsDto,
        quizRepo.findUsernameFromQuizId(quiz.getQuizId()).get());
  }

  /**
   * Maps a quiz question entity to a quiz question DTO.
   *
   * @param question The quiz question entity.
   * @return The quiz question DTO.
   */
  public static QuizQuestionDto mapToQuestionDto(QuizQuestion question) {

    List<QuizOptionDto> optionsDto = question.getQuizOptions().stream()
        .map(option -> new QuizOptionDto(option.getQuizOptionId(), option.getOptionText(),
            option.isCorrect()))
        .collect(Collectors.toList());

    return new QuizQuestionDto(question.getQuizQuestionId(), question.getQuestion(), optionsDto);
  }
}
