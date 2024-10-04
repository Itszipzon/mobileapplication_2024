import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class QuizPost extends StatelessWidget {
  const QuizPost({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final router = RouterProvider.of(context);
    return InkWell(
        onTap: () {
          router.setPath(context, path);
        },
        child: SizedBox(
          child: Container(
              padding: const EdgeInsets.only(left: 16),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: NetworkImage(
                      "https://cdn1.epicgames.com/offer/e860fa919120430ca12c557bb676bc6a/EGST_StoreLandscape_2560x1440_2560x1440-e7beda03979167bed00fb2c73bb7998a",
                    ),
                    height: 96,
                    width: 212,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image(
                          image: NetworkImage(
                            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia-cldnry.s-nbcnews.com%2Fimage%2Fupload%2Fnewscms%2F2021_51%2F1824063%2Fjaden-smith-kb-main-211224.jpg&f=1&nofb=1&ipt=d85d8ff12568b5a86082486d5c62f44e2462dd0691d08949907688fecbfbd696&ipo=images",
                          ),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
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
