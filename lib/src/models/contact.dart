import 'package:dart_nostr/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../utils.dart';

part 'contact.g.dart';

@Collection(ignore: {'props'})
class Contact extends Equatable {
  late final Id id = fastHash(keySet.value!.pubKeyHex);
  final keySet = IsarLink<Nip19KeySet>();
  final profile = IsarLink<Profile>();
  final bool following;

  Contact({
    this.following = false,
    Nip19KeySet? keyset,
    Profile? profile,
  }) {
    if (keyset != null) keySet.value = keyset;
    if (profile != null) this.profile.value = profile;
  }

  String get pubkeyHex => keySet.value!.pubKeyHex;

  @override
  List<Object> get props => [...profile.value!.props, following];

  Contact copyWith({bool? following}) {
    return Contact(
      following: following ?? this.following,
      keyset: keySet.value,
      profile: profile.value,
    );
  }

  Contact.empty([Nip19KeySet? keyset]) : following = false;

  Map<String, dynamic> toJson() {
    return {
      'pubkey': keySet.value ?? keySet.value?.toJson(),
      'profile': profile.value!.toJson(),
      'following': following,
    };
  }
}
