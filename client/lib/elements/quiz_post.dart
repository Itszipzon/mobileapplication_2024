import 'package:client/elements/profile_picture.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizPost extends ConsumerWidget {
  const QuizPost(
      {super.key,
      required this.path,
      required this.thumbnail,
      required this.profilePicture});

  final String path;
  final String thumbnail;
  final String profilePicture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider.notifier);
    return InkWell(
        onTap: () {
          router.setPath(context, path);
        },
        child: SizedBox(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: NetworkImage(thumbnail),
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Starwars Quiz"),
                          SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Jan Nor"),
                              SizedBox(width: 8),
                              Row(children: [
                                Text("169 Views"),
                                SizedBox(width: 8),
                                Text("6 days ago")
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
