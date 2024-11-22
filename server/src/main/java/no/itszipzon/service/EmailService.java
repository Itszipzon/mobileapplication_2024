package no.itszipzon.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendEmail(String to, String subject, String body) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);
        message.setFrom("gruppeseks123@gmail.com");

        mailSender.send(message);
    }

    public void sendHtmlEmail(String to, String subject, String name, String filePath, Map<String, String> replacements) throws MessagingException, IOException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

        Context context = new Context();
        context.setVariable("name", name);

        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(loadHtmlTemplate(filePath, replacements), true);
        helper.setFrom("gruppeseks123@gmail.com");

        mailSender.send(message);
    }

    private String loadHtmlTemplate(String filePath, Map<String, String> replacements) throws IOException {
        String content = new String(Files.readAllBytes(Paths.get(filePath)));

        for (Map.Entry<String, String> entry : replacements.entrySet()) {
            content = content.replace("{{" + entry.getKey() + "}}", entry.getValue());
        }

        return content;
    }
}
