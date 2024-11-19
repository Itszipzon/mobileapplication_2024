package no.itszipzon.api;

import io.jsonwebtoken.Claims;
import no.itszipzon.Logger;
import no.itszipzon.config.JwtUtil;
import no.itszipzon.dto.FriendDto;
import no.itszipzon.repo.FriendRepo;
import no.itszipzon.repo.UserRepo;
import no.itszipzon.tables.Friend;
import no.itszipzon.tables.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("api/friends")
public class FriendApi {

    @Autowired
    private FriendRepo friendRepo;

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<List<FriendDto>> getFriends(
            @RequestHeader("Authorization") String authorizationHeader) {
        Claims claims = validateToken(authorizationHeader);
        if (claims == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        List<FriendDto> friends = friendRepo.findUserFriends(claims.getSubject());
        return new ResponseEntity<>(friends, HttpStatus.OK);
    }

    @GetMapping("/pending")
    public ResponseEntity<List<FriendDto>> getPendingRequests(
            @RequestHeader("Authorization") String authorizationHeader) {
        Claims claims = validateToken(authorizationHeader);
        if (claims == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        List<FriendDto> pending = friendRepo.findPendingFriendRequests(claims.getSubject());
        return new ResponseEntity<>(pending, HttpStatus.OK);
    }

    @PostMapping("/request/{username}")
    public ResponseEntity<String> sendFriendRequest(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable String username) {
        Claims claims = validateToken(authorizationHeader);
        if (claims == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        if (claims.getSubject().equals(username)) {
            return new ResponseEntity<>("Cannot send friend request to yourself", HttpStatus.BAD_REQUEST);
        }

        Optional<User> targetUser = userRepo.findUserByUsername(username);
        if (targetUser.isEmpty()) {
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }

        Optional<Friend> existingFriendship = friendRepo.findFriendship(claims.getSubject(), username);
        if (existingFriendship.isPresent()) {
            return new ResponseEntity<>("Friend request already exists", HttpStatus.BAD_REQUEST);
        }

        User requestingUser = userRepo.findUserByUsername(claims.getSubject()).get();
        Friend friend = new Friend();
        friend.setUser(requestingUser);
        friend.setFriendUser(targetUser.get());
        friend.setStatus("PENDING");
        friendRepo.save(friend);

        Logger.log("User " + claims.getSubject() + " sent friend request to " + username);
        return new ResponseEntity<>("Friend request sent", HttpStatus.OK);
    }

    @PostMapping("/accept/{friendId}")
    public ResponseEntity<String> acceptFriendRequest(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable Long friendId) {
        Claims claims = validateToken(authorizationHeader);
        if (claims == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        Optional<Friend> friendRequest = friendRepo.findById(friendId);
        if (friendRequest.isEmpty() || !friendRequest.get().getFriendUser().getUsername().equals(claims.getSubject())) {
            return new ResponseEntity<>("Friend request not found", HttpStatus.NOT_FOUND);
        }

        Friend friend = friendRequest.get();
        friend.setStatus("ACCEPTED");
        friend.setAcceptedAt(LocalDateTime.now());
        friendRepo.save(friend);

        Logger.log("User " + claims.getSubject() + " accepted friend request from " + friend.getUser().getUsername());
        return new ResponseEntity<>("Friend request accepted", HttpStatus.OK);
    }

    @DeleteMapping("/{username}")
    public ResponseEntity<String> removeFriend(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable String username) {
        Claims claims = validateToken(authorizationHeader);
        if (claims == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        Optional<Friend> friendship = friendRepo.findFriendship(claims.getSubject(), username);
        if (friendship.isEmpty()) {
            return new ResponseEntity<>("Friendship not found", HttpStatus.NOT_FOUND);
        }

        friendRepo.delete(friendship.get());
        Logger.log("User " + claims.getSubject() + " removed friend " + username);
        return new ResponseEntity<>("Friend removed", HttpStatus.OK);
    }

    private Claims validateToken(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return null;
        }
        String token = authorizationHeader.substring(7);
        return jwtUtil.extractClaims(token);
    }
}