import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/review.dart';
import 'package:thirst_quest/api/models/vote_type.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:thirst_quest/states/global_state.dart';

class LikeDislikeButton extends StatefulWidget {
  final WaterBubbler waterBubbler;

  const LikeDislikeButton({required this.waterBubbler, super.key});

  @override
  State<StatefulWidget> createState() => LikeDislikeButtonState();
}

class LikeDislikeButtonState extends State<LikeDislikeButton> {
  final WaterBubblerService waterBubblerService = DI.get<WaterBubblerService>();
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    Review? review = widget.waterBubbler.review;
    if (review != null) {
      isLiked = review.voteTypeEnum == VoteType.UPVOTE ? true : false;
      isDisliked = !isLiked;
    }
  }

  void _redirectToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(popOnSuccess: true),
      ),
    );
  }

  void _onPresedLike() async {
    final mapState = context.read<BubblerMapState>();
    String? revId = widget.waterBubbler.review?.id;
    Review review = Review.createReview(
        reviewId: revId,
        voteTypeEnum: VoteType.UPVOTE,
        waterBubblerId: widget.waterBubbler.id,
        waterBubblerOsmId: widget.waterBubbler.osmId);
    bool negReview = false;
    setState(() {
      isLiked = !isLiked;
      if (isDisliked) {
        isDisliked = false;
        negReview = true;
        widget.waterBubbler.upvoteCount++;
        widget.waterBubbler.downvoteCount--;
        widget.waterBubbler.review = review;
      } else if (isLiked) {
        widget.waterBubbler.upvoteCount++;
        widget.waterBubbler.review = review;
      } else {
        widget.waterBubbler.upvoteCount--;
        widget.waterBubbler.review = null;
      }
    });

    mapState.selectedBubbler = widget.waterBubbler;

    if (negReview) {
      // review was dislike
      await waterBubblerService.updateReview(review);
    } else if (isLiked) {
      // no previous review
      await waterBubblerService.addReview(review);
    } else {
      // review was like
      await waterBubblerService.deleteReview(widget.waterBubbler.id, widget.waterBubbler.osmId);
    }
  }

  void _onPresedDislike() async {
    final mapState = context.read<BubblerMapState>();
    String? revId = widget.waterBubbler.review?.id;
    Review review = Review.createReview(
        reviewId: revId,
        voteTypeEnum: VoteType.DOWNVOTE,
        waterBubblerId: widget.waterBubbler.id,
        waterBubblerOsmId: widget.waterBubbler.osmId);
    bool posReview = false;
    setState(() {
      isDisliked = !isDisliked;
      if (isLiked) {
        isLiked = false;
        posReview = true;
        widget.waterBubbler.upvoteCount--;
        widget.waterBubbler.downvoteCount++;
        widget.waterBubbler.review = review;
      } else if (isDisliked) {
        widget.waterBubbler.downvoteCount++;
        widget.waterBubbler.review = review;
      } else {
        widget.waterBubbler.downvoteCount--;
        widget.waterBubbler.review = null;
      }
    });

    mapState.selectedBubbler = widget.waterBubbler;

    if (posReview) {
      // review was like
      await waterBubblerService.updateReview(review);
    } else if (isDisliked) {
      // no previous review
      await waterBubblerService.addReview(review);
    } else {
      // review was dislike
      await waterBubblerService.deleteReview(widget.waterBubbler.id, widget.waterBubbler.osmId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();
    final int upVotesCount = widget.waterBubbler.upvoteCount;
    final int downVotesCount = widget.waterBubbler.downvoteCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Like Button
        GestureDetector(
          onTap: () {
            globalState.user.isLoggedIn ? _onPresedLike() : _redirectToLogin();
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
            color: assignColorToBubblerVotes(upVotesCount, downVotesCount).withOpacity(0.7),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "${upVotesCount - downVotesCount}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(width: 10),
        // Dislike Button
        GestureDetector(
          onTap: () {
            globalState.user.isLoggedIn ? _onPresedDislike() : _redirectToLogin();
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
