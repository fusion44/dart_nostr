import 'dart:convert';

import 'package:isar/isar.dart';

part 'tag.g.dart';

enum TagType { event, profile, unknown }

String _tagTypeAbbrev(TagType tt) {
  switch (tt) {
    case TagType.event:
      return 'e';
    case TagType.profile:
      return 'p';
    default:
      return '';
  }
}

@embedded
class Tag {
  final EventTag? eventTag;
  final ProfileTag? profileTag;
  final UnknownTag? unknown;

  @enumerated
  late final TagType type;

  Tag({this.eventTag, this.profileTag, this.unknown}) {
    if (eventTag != null) {
      type = TagType.event;
    } else if (profileTag != null) {
      type = TagType.profile;
    } else {
      type = TagType.unknown;
    }
  }

  factory Tag.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      if (json[0] == 'e') {
        return Tag(eventTag: EventTag.fromJson(json));
      } else if (json[0] == 'p') {
        return Tag(profileTag: ProfileTag.fromJson(json));
      } else {
        return Tag(unknown: UnknownTag(data: jsonEncode(json)));
      }
    } else {
      throw StateError('Invalid JSON: $json');
    }
  }

  List<dynamic> toJson() => [_tagTypeAbbrev(type)];

  @override
  String toString() {
    if (eventTag != null) {
      return eventTag.toString();
    } else if (profileTag != null) {
      return profileTag.toString();
    } else {
      return unknown.toString();
    }
  }
}

@embedded
class EventTag {
  final String eventId;
  final String recommendedRelayUrl;

  EventTag({
    this.eventId = '',
    this.recommendedRelayUrl = '',
  });

  EventTag.fromJson(List<dynamic> v)
      : eventId = v[1],
        recommendedRelayUrl = v.length > 2 ? v[2] : '';

  List<dynamic> toJson() =>
      [_tagTypeAbbrev(TagType.event), eventId, recommendedRelayUrl];

  @override
  String toString() =>
      'EventTag{eventId: $eventId, recommendedRelayUrl: $recommendedRelayUrl}';
}

@embedded
class ProfileTag {
  final String profileId;
  final String recommendedRelayUrl;
  final String petName;

  ProfileTag({
    this.profileId = '',
    this.recommendedRelayUrl = '',
    this.petName = '',
  });

  ProfileTag.fromJson(List v)
      : profileId = v[1],
        recommendedRelayUrl = v.length > 2 ? v[2] : '',
        petName = v.length > 3 ? v[3] : '';

  List<dynamic> toJson() => [
        _tagTypeAbbrev(TagType.profile),
        profileId,
        recommendedRelayUrl,
        petName,
      ];

  @override
  String toString() =>
      'ProfileTag{profileId: $profileId, recommendedRelayUrl: $recommendedRelayUrl, petName: $petName}';
}

@embedded
class UnknownTag {
  final String data;

  UnknownTag({this.data = ''});

  @override
  String toString() => 'UnknownTag{data: $data}';
}
