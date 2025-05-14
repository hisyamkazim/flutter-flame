class Scores {
  final int score;
  final DateTime date;

  Scores({required this.score, required this.date});

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      score: json['score'],
      date: DateTime.parse(json['date']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'date': date.toIso8601String(),
    };
  }
}
