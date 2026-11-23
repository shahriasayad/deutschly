class ListeningTask {
  const ListeningTask({
    required this.id,
    required this.prompt,
    required this.spokenText,
    required this.options,
    required this.correctIndex,
  });

  final String id;
  final String prompt;
  final String spokenText;
  final List<String> options;
  final int correctIndex;
}
