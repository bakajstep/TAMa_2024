import 'package:json_annotation/json_annotation.dart';

enum VoteType {
  @JsonValue('UPVOTE')
  UPVOTE,
  @JsonValue('DOWNVOTE')
  DOWNVOTE
}
