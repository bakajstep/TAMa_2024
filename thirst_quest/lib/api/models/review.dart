import 'package:json_annotation/json_annotation.dart';
import 'package:thirst_quest/api/models/vote_type.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final String id;
  final VoteType voteType;
  final String userId;
  final String? waterBubblerId;
  final int? waterBubblerOsmId;

  Review({
    required this.id,
    required this.voteType,
    required this.userId,
    required this.waterBubblerId,
    required this.waterBubblerOsmId,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Review.createReview({
    required String? reviewId,
    required this.voteType,
    required this.waterBubblerId,
    required this.waterBubblerOsmId,
  })  : id = reviewId ?? "",
        userId = "";

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
