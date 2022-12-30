///Thrown when a given mnemonic is invalid
class InvalidMnemonicError implements Exception {
  final String message;

  InvalidMnemonicError([this.message = 'Invalid mnemonic']);

  @override
  String toString() => message;
}
