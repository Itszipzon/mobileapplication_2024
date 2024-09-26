import 'package:flutter/material.dart';

class QuizPost extends StatelessWidget {
  const QuizPost({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 303,
      child: Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(
                  "https://cdn1.epicgames.com/offer/e860fa919120430ca12c557bb676bc6a/EGST_StoreLandscape_2560x1440_2560x1440-e7beda03979167bed00fb2c73bb7998a",
                ),
                height: 205,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image(
                      image: NetworkImage(
                        "https://s3-alpha-sig.figma.com/img/0eca/bb54/59bcff2ad62e84f254bb90af501fae16?Expires=1728259200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=B5XDz4kWXaF~34~sZGaWxo4Jd1~lFfQzCLX5TOQ2VrmYwSgt5buMORIWL0faLh9P5pyHl2TJfe3NTeCksrOm71-TxOaKNgNPzDiawji5R8QB1IqxUtOJRJj2UZzlINyySo8Ma-7~WNc28v6HTE4PV7UHyW-JMRSvhRCLCfJNdGzObmCge9e7HN6W1ERBq5atmTj4z54C7uQMiBtoXwD1pLKheXeFV-jl7E9ce491Wsb9~hhvZxgMdQrBmCDrWMjZhxJGMZ0U7XJvf7uPw-cRvCntZSbmGw2t1GVWPk1lvRPhKF0pNlcFeDNcfGhL4oDiHLx5zjawb7wxTpNJiCyWEw__",
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
                      Row(
                        children: [
                          Text("Jan Nor"),
                          SizedBox(width: 8),
                          Text("169 Views"),
                          SizedBox(width: 8),
                          Text("6 days ago"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
