import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/review.dart';
import 'package:thirst_quest/api/models/vote_type.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/assign_color_to_bubbler_votes.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/screens/main_screen.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/states/bubbler_map_state.dart';
import 'package:provider/provider.dart';
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
    final mapState = context.read<BubblerMapState>();

    ModalRoute.of(context)?.settings.name;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
            onLoginSuccess: MaterialPageRoute(
                builder: (context) => MainScreen(initialPosition: mapState.mapController.camera.center))),
      ),
    );
  }

  void _onPresedLike() async {
    Review review = Review.createReview(voteTypeEnum: VoteType.UPVOTE, waterBubblerId: widget.waterBubbler.id, waterBubblerOsmId: widget.waterBubbler.osmId);
    bool negReview = false;
    String? revId = widget.waterBubbler.review?.id;
    // if (widget.waterBubbler.review != null) {
    //   revId = widget.waterBubbler.review!.id;
    // }

    setState(() {
      isLiked = !isLiked;
      // if (isLiked && isDisliked) {
      //   isDisliked = false;
      //   widget.waterBubbler.upvoteCount++;
      //   widget.waterBubbler.review = review;
      // }
      if (isDisliked) {
        isDisliked = false;
        negReview = true;
        widget.waterBubbler.upvoteCount++;
        widget.waterBubbler.downvoteCount--;
        widget.waterBubbler.review = review;
      }
      else if (isLiked) {
        widget.waterBubbler.upvoteCount++;
        widget.waterBubbler.review = review;
      }
      else {
        widget.waterBubbler.upvoteCount--;
        widget.waterBubbler.review = null;
      }
    });

    // TODO: null check cuz of refresh error
    if (negReview && widget.waterBubbler.review != null) { // review was dislike 
      await waterBubblerService.updateReview(revId!, VoteType.UPVOTE);
    }
    else if (isLiked) { // no previous review
      await waterBubblerService.addReview(review);
    }
    else { // review was like
      await waterBubblerService.deleteReview(revId!);
    }






    // if (!isLiked || delReview) {
    //   await waterBubblerService.deleteReview(widget.waterBubbler); // isLiked was true, delete review
    // }

    // if (isLiked) {
    //   await waterBubblerService.addReview(review);
    // }


    
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
          //   if (globalState.user.isLoggedIn) {
          //     setState(() {
          //       isLiked = !isLiked;
          //       if (isLiked) {
          //         isDisliked = false;
                  
          //       }
          //     });
          //   } else {
          //     _redirectToLogin();
          //   }
          // },
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
            if (globalState.user.isLoggedIn) {
              setState(() {
                isDisliked = !isDisliked;
                if (isDisliked) isLiked = false;
              });
            } else {
              _redirectToLogin();
            }
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
