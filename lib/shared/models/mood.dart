/// Les trois familles d'humeur, qui servent notamment à la météo du couple.
enum MoodFamily { sun, soft, storm }

/// Les 9 humeurs de Ryou, dans l'ordre du design system.
enum Mood {
  joy(MoodFamily.sun, '😄'),
  love(MoodFamily.sun, '🥰'),
  hype(MoodFamily.sun, '🤩'),
  zen(MoodFamily.soft, '😌'),
  hug(MoodFamily.soft, '🤗'),
  flat(MoodFamily.soft, '😴'),
  sad(MoodFamily.storm, '😢'),
  stress(MoodFamily.storm, '😬'),
  mad(MoodFamily.storm, '😤');

  const Mood(this.family, this.emoji);

  final MoodFamily family;
  final String emoji;
}
