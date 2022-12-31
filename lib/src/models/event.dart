import 'dart:convert';

import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:hex/hex.dart';
import 'package:isar/isar.dart';

import '../utils.dart';
import 'models.dart';

part 'event.g.dart';

@Collection(ignore: {'props'})
class Event extends Equatable {
  late final Id id = fastHash(nostrId);
  final String channel;
  final String nostrId;
  final String pubkey;
  final DateTime createdAtDt;
  final int kind;
  final String content;
  final String sig;
  final bool verified;
  final List<Tag> tags = [];
  final List<String> relays = [];
  final _parents = IsarLinks<Event>();
  final _children = IsarLinks<Event>();

  int get numParents => _parents.length;
  int get numChildren => _children.length;

  IsarLinks<Event> get parents => _parents;
  IsarLinks<Event> get children => _children;

  int get createdAt => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Event({
    required this.pubkey,
    required this.createdAtDt,
    required this.kind,
    this.channel = '0',
    this.nostrId = '',
    this.content = '',
    this.sig = '',
    this.verified = false,
    List<Event>? parents,
    List<Event>? children,
  }) {
    if (parents != null && parents.isNotEmpty) _parents.addAll(parents);
    if (children != null && children.isNotEmpty) _children.addAll(children);
  }

  Event.empty()
      : channel = '0',
        nostrId = '',
        pubkey = '',
        createdAtDt = DateTime.now(),
        kind = NostrKind.empty,
        content = '',
        sig = '',
        verified = false;

  static Future<Event> textEvent({
    required String pubKey,
    required String privKey,
    required String content,
    List<Tag> tags = const [],
    DateTime? createdAt,
  }) async {
    final e = Event(
      pubkey: pubKey,
      createdAtDt: createdAt ?? DateTime.now(),
      kind: NostrKind.note,
      content: content,
    )..tags.addAll(tags);

    return await e.signWith(privKey);
  }

  /// Event to publish a the a contact list to relays
  /// https://github.com/fiatjaf/nostr/blob/master/nips/02.md
  Event.publishContacts(String pubKey)
      : pubkey = pubKey,
        createdAtDt = DateTime.now(),
        nostrId = '',
        kind = NostrKind.contacts,
        content = '',
        channel = '0',
        sig = '',
        verified = false;

  @override
  List<Object> get props => [
        channel,
        nostrId,
        relays,
        pubkey,
        createdAt,
        kind,
        ...tags,
        content,
        sig,
        ...parents,
        ...children,
      ];

  static Event fromJson(
    Map<String, dynamic> json, {
    List<Relay> relays = const [],
    String channel = '0',
  }) {
    final e = Event(
      channel: channel,
      nostrId: json['id'],
      pubkey: json['pubkey'],
      createdAtDt:
          DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
      kind: json['kind'] ?? NostrKind.empty,
      content: json['content'],
      sig: json['sig'],
    );

    e.relays.addAll(relays.map((e) => e.url));
    if (json['tags'] != null && json['tags'].isNotEmpty) {
      json['tags'].forEach((v) {
        e.tags.add(Tag.fromJson(v));
      });
    }

    return e;
  }

  bool hasChild(Event a) {
    for (var b in _children) {
      if (a.nostrId == b.nostrId) return true;
    }

    return false;
  }

  bool hasParent(Event a) {
    for (var b in _children) {
      if (a.nostrId == b.nostrId) return true;
    }

    return false;
  }

  Event copyWith({
    String? channel,
    List<String>? relays,
    String? nostrId,
    String? pubkey,
    int? createdAt,
    int? kind,
    List<Tag>? tags,
    String? content,
    String? sig,
    bool? verified,
    Event? parent,
    Event? child,
  }) {
    return Event(
      channel: channel ?? this.channel,
      nostrId: nostrId ?? this.nostrId,
      pubkey: pubkey ?? this.pubkey,
      createdAtDt: createdAt != null
          ? DateTime.fromMillisecondsSinceEpoch(createdAt * 1000)
          : createdAtDt,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      sig: sig ?? this.sig,
      verified: verified ?? this.verified,
      parents: parent != null ? [...parents, parent] : [...parents],
      children: child != null ? [...children, child] : [...children],
    )
      ..relays.addAll(relays ?? this.relays)
      ..tags.addAll(tags ?? this.tags);
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['id'] = nostrId;
    data['pubkey'] = pubkey;
    data['created_at'] = createdAt;
    data['kind'] = kind;
    data['tags'] = tags.map((v) => v.toJson()).toList();
    data['content'] = content;
    data['sig'] = sig;
    return data;
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() {
    return json.encode(toMap());
  }

  Future<Event> signWith(String key) async {
    final eventHash = _hashHEX();
    final sig = bip340.sign(key, eventHash, HEX.encode(randomBytes32()));

    return copyWith(nostrId: eventHash, sig: sig, verified: await verify());
  }

  Future<bool> verify() async {
    final eventHash = _hashHEX();

    return bip340.verify(pubkey, eventHash, sig);
  }

  String _serialize() {
    final s = json.encode([
      0,
      pubkey,
      createdAt,
      kind,
      tags.toList(),
      content,
    ]); //.replaceAll(RegExp(r'\s+'), '');

    return s;
  }

  String _hashHEX() {
    final bytes = utf8.encode(_serialize());
    final eventHash = sha256.convert(bytes);
    final h = HEX.encode(eventHash.bytes);

    return h;
  }
}
