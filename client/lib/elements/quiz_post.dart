import 'package:client/elements/profile_picture.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizPost extends ConsumerWidget {
  const QuizPost({
    super.key,
    required this.id,
    required this.profilePicture,
    required this.title,
    required this.username,
    required this.createdAt,
  });

  final int id;
  final String profilePicture;
  final String title;
  final String username;
  final DateTime createdAt;

  String _formatCreatedAt(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      if ((difference.inDays / 365).floor() == 1) {
        return '1 year ago';
      }
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays >= 30) {
      if ((difference.inDays / 30).floor() == 1) {
        return '1 month ago';
      }
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays >= 7) {
      if ((difference.inDays / 7).floor() == 1) {
        return '1 week ago';
      }
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      }
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      }
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider.notifier);
    return GestureDetector(
      onTap: () {
        router.setPath(context, "quiz", values: {"id": id});
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage("${ApiHandler.url}/api/quiz/thumbnail/$id"),
              height: 96,
              width: 212,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: ProfilePicture(
                    url: profilePicture,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(username),
                    const SizedBox(height: 4),
                    Text(_formatCreatedAt(createdAt)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
