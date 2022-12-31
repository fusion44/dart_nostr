import 'package:isar/isar.dart';

part 'nip05_verification_result.g.dart';

@collection
class Nip05 {
  final Id id = Isar.autoIncrement;
  final bool verified;
  final String domain;
  final DateTime verifiedAt;

  Nip05(this.verified, this.domain, this.verifiedAt);

  Nip05.empty()
      : verified = false,
        domain = '',
        verifiedAt = DateTime.now();

  Nip05.verified(this.domain)
      : verified = true,
        verifiedAt = DateTime.now();

  Nip05.unverified([this.domain = ''])
      : verified = false,
        verifiedAt = DateTime.now();

  Nip05.fromJson(Map<String, dynamic> json)
      : verified = json['verified'] ?? false,
        domain = json['domain'] ?? '',
        verifiedAt = json['verifiedAt'] ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
      'domain': domain,
      'verifiedAt': verifiedAt,
    };
  }
}
