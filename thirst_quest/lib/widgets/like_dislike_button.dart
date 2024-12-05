import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';

class LikeDislikeButton extends StatefulWidget {
    final WaterBubbler waterBubbler;

  const LikeDislikeButton({required this.waterBubbler, super.key});

  @override
  State<StatefulWidget> createState() => LikeDislikeButtonState();
}

class LikeDislikeButtonState extends State<LikeDislikeButton> {
  bool isLiked = false;
  bool isDisliked = false;

  @override
  Widget build(BuildContext context) {
    final int upVotesCount = widget.waterBubbler.upvoteCount;
    final int downVotesCount = widget.waterBubbler.downvoteCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Like Button
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) isDisliked = false;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isLiked ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isLiked
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up,
                  color: isLiked ? Colors.green : Colors.grey,
                ),
                // SizedBox(width: 8),
                // Text(
                //   'Like',
                //   style: TextStyle(
                //     color: isLiked ? Colors.green : Colors.grey,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: assignColorToBubblerVotes(upVotesCount, downVotesCount),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "${upVotesCount - downVotesCount}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
        ),
        SizedBox(width: 10),
        // Dislike Button
        GestureDetector(
          onTap: () {
            setState(() {
              isDisliked = !isDisliked;
              if (isDisliked) isLiked = false;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDisliked ? Colors.red.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isDisliked
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_down,
                  color: isDisliked ? Colors.red : Colors.grey,
                ),
                // SizedBox(width: 8),
                // Text(
                //   'Dislike',
                //   style: TextStyle(
                //     color: isDisliked ? Colors.red : Colors.grey,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
