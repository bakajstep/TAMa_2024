import 'package:flutter/material.dart';

Color assignColorToBubblerVotes(int upvoteCount, int downvoteCount) {
  if (upvoteCount == 0 && downvoteCount == 0) {
    return Colors.grey;
  }

  final totalVotes = upvoteCount + downvoteCount;
  final upvotePercentage = upvoteCount / totalVotes;

  if (upvotePercentage > 0.55) {
    return Colors.green;
  } else if (upvotePercentage > 0.45) {
    return Colors.grey;
  } else {
    return Colors.red;
  }
}