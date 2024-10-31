import 'package:client/dummy_data.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String url;
  final double size;
  final BoxFit? fit;

  const ProfilePicture({super.key, required this.url, this.size = 79, this.fit});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image(
        image: url != "null" && url.isNotEmpty ? NetworkImage(url) : NetworkImage(DummyData.profilePicture),
        width: size,
        height: size,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}