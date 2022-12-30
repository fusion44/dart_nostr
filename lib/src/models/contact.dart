import 'package:dart_nostr/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../utils.dart';

part 'contact.g.dart';

@Collection(ignore: {'props'})
class Contact extends Equatable {
  late final Id id = fastHash(keySet.value!.pubKeyHex);
  final keySet = IsarLink<Nip19KeySet>();
  final Profile profile;
  final bool following;

  Contact({
    required this.profile,
    this.following = false,
    Nip19KeySet? keyset,
  }) {
    if (keyset != null) keySet.value = keyset;
  }

  String get pubkeyHex => keySet.value!.pubKeyHex;

  @override
  List<Object> get props => [...profile.props, following];

  Contact copyWith({Profile? profile, bool? following}) {
    return Contact(
      profile: profile ?? this.profile,
      following: following ?? this.following,
      keyset: keySet.value,
    );
  }

  Contact.empty([Nip19KeySet? keyset])
      : profile = Profile(),
        following = false;

  Map<String, dynamic> toJson() {
    return {
      'pubkey': keySet.value ?? keySet.value?.toJson(),
      'profile': profile.toJson(),
      'following': following,
    };
  }
}
