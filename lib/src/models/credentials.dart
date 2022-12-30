import 'nip19_key_set.dart';

class Credentials {
  final Nip19KeySet pubKey;
  final String privKey;
  final String mnemonic;

  Credentials({
    required this.pubKey,
    required this.privKey,
    this.mnemonic = '',
  });
}
