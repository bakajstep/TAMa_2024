import 'package:flutter/material.dart';
import 'package:thirst_quest/utils/double_compare.dart';

Color assignColorToBubblerVotes(int upvoteCount, int downvoteCount) {
  if (upvoteCount == 0 && downvoteCount == 0) {
    return Colors.grey;
  }

  final totalVotes = upvoteCount + downvoteCount;
  final upvotePercentage = upvoteCount / totalVotes;

  if (upvotePercentage <= 0.2) {
    return Colors.red;
  } else if (upvotePercentage <= 0.4) {
    return Colors.deepOrangeAccent;
  } else if (upvotePercentage <= 0.6) {
    return Colors.yellow;
  } else if (upvotePercentage <= 0.8) {
    return Colors.lightGreen;
  } else {
    return Colors.green;
  }
}

bool isInHappinessLevel(int level, int upvoteCount, int downvoteCount) {
  final totalVotes = upvoteCount + downvoteCount;
  final upvotePercentage = totalVotes == 0 ? 0.6 : upvoteCount / totalVotes; // neutral for no votes

  return doubleLessThan((level - 1) * 0.2, upvotePercentage);
}

Color getColorByLevel(int level) {
  switch (level) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.deepOrangeAccent;
    case 3:
      return Colors.yellow;
    case 4:
      return Colors.lightGreen;
    case 5:
      return Colors.green;
    default:
      return Colors.grey;
  }
}
