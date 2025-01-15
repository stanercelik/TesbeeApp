class PredefinedDhikr {
  final Map<String, String> title;
  final String arabic;
  final String transliteration;
  final Map<String, String> meaning;
  final int targetCount;
  final Map<String, String> category;

  PredefinedDhikr({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.targetCount,
    required this.category,
  });

  factory PredefinedDhikr.fromJson(Map<String, dynamic> json) {
    return PredefinedDhikr(
      title: Map<String, String>.from(json['title'] as Map),
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: Map<String, String>.from(json['meaning'] as Map),
      targetCount: json['targetCount'] as int,
      category: Map<String, String>.from(json['category'] as Map),
    );
  }
}
