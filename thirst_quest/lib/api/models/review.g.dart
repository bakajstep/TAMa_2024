// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as String,
      voteType: json['voteType'] as String,
      userId: json['userId'] as String,
      waterBubblerId: json['waterBubblerId'] as String?,
      waterBubblerOsmId: (json['waterBubblerOsmId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'voteType': instance.voteType,
      'userId': instance.userId,
      'waterBubblerId': instance.waterBubblerId,
      'waterBubblerOsmId': instance.waterBubblerOsmId,
      'voteTypeEnum': _$VoteTypeEnumMap[instance.voteTypeEnum]!,
    };

const _$VoteTypeEnumMap = {
  VoteType.UPVOTE: 'UPVOTE',
  VoteType.DOWNVOTE: 'DOWNVOTE',
};
