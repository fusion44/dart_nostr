// https://github.com/nostr-protocol/nips#event-kinds1
class NostrKind {
  static const int empty = -1;
  static const int metadata = 0;
  static const int note = 1;
  static const int recommendRelay = 2;
  static const int contacts = 3;
  static const int encryptedDirectMessages = 4;
  static const int eventDeletion = 5;
  static const int reaction = 7;
  static const int channelCreation = 40;
  static const int channelMetadata = 41;
  static const int channelMessage = 42;
  static const int channelHideMessage = 43;
  static const int channelMuteUser = 44;
  // 45    - 49	    Public Chat Reserved
  // 10000 - 19999  Replaceable Events Reserved
  // 20000 - 29999	Ephemeral Events Reserved
}
