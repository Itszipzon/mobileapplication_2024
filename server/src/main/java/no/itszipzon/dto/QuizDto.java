package no.itszipzon.dto;

import java.util.List;

public class QuizDto {

    private long id;
    private String title;
    private String description;
    private String thumbnail;
    private Integer timer;
    private List<QuizQuestionDto> quizQuestions;


    public QuizDto(long id, String title, String description, String thumbnail, Integer timer) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.thumbnail = thumbnail;
        this.timer = timer;
    }


    public QuizDto(long id, String title, String description, String thumbnail, Integer timer,
            List<QuizQuestionDto> quizQuestions) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.thumbnail = thumbnail;
        this.timer = timer;
        this.quizQuestions = quizQuestions;
    }

 
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public Integer getTimer() {
        return timer;
    }

    public void setTimer(Integer timer) {
        this.timer = timer;
    }

    public List<QuizQuestionDto> getQuizQuestions() {
        return quizQuestions;
    }

    public void setQuizQuestions(List<QuizQuestionDto> quizQuestions) {
        this.quizQuestions = quizQuestions;
    }
}
