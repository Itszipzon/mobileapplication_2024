package no.itszipzon.repo;

import no.itszipzon.tables.ResetToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface ResetTokenRepo extends JpaRepository<ResetToken, Long> {
    Optional<ResetToken> findByToken(String token);

    void deleteByUser_Email(String email);
}
