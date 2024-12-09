// import 'package:flutter/material.dart';

// Color assignColorToBubblerVotes(int upvoteCount, int downvoteCount) {
//   if (upvoteCount == 0 && downvoteCount == 0) {
//     return Colors.grey;
//   }

//   final totalVotes = upvoteCount + downvoteCount;
//   final upvotePercentage = upvoteCount / totalVotes;

//   if (upvotePercentage > 0.55) {
//     return Colors.green;
//   } else if (upvotePercentage > 0.45) {
//     return Colors.grey;
//   } else {
//     return Colors.red;
//   }
// }

import 'package:flutter/material.dart';

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
