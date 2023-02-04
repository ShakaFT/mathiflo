class CuddlyToysHistory {
  CuddlyToysHistory(
    this.florent,
    this.mathilde,
    this.timestamp, {
    this.token = "",
    this.hasMore = false,
  });

  bool hasMore = false;
  List<String> florent;
  List<String> mathilde;
  int timestamp;
  String token;

  toMap() => {
        "Florent": florent,
        "Mathilde": mathilde,
        "timestamp": timestamp,
        "token": token
      };
}
