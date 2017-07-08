class PullRequest {

  final String title;
  final int number;

  PullRequest(this.title, this.number);

  factory PullRequest.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new PullRequest(json['title'], json['number']);
    }
  }
}
