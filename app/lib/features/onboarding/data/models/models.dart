import 'package:flutter/material.dart';

class Question {
  final int id;
  final String text;
  final List<Option> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });
}

class Option {
  final int id;
  final String text;
  final IconData? icon;

  Option({
    required this.id,
    required this.text,
    this.icon,
  });
}

// ==================== YOUR QUESTIONS DATA ====================
final List<Question> questionList = [
  Question(
    id: 1,
    text: "What brings you here today?",
    options: [
      Option(id: 1, text: "Build strength & muscle", icon: Icons.fitness_center),
      Option(id: 2, text: "Lose weight & get fit", icon: Icons.trending_down),
      Option(id: 3, text: "Improve mindset & focus", icon: Icons.psychology),
      Option(id: 4, text: "Build better daily habits", icon: Icons.repeat),
    ],
  ),
  Question(
    id: 2,
    text: "How would you describe your current energy levels?",
    options: [
      Option(id: 1, text: "Very low — I feel tired often", icon: Icons.battery_0_bar),
      Option(id: 2, text: "Average — some good days, some bad", icon: Icons.battery_3_bar),
      Option(id: 3, text: "Good — I have decent energy", icon: Icons.battery_5_bar),
      Option(id: 4, text: "Excellent — I feel energized daily", icon: Icons.battery_full),
    ],
  ),
  Question(
    id: 3,
    text: "What’s your biggest challenge right now?",
    options: [
      Option(id: 1, text: "Staying consistent with habits", icon: Icons.timeline),
      Option(id: 2, text: "Managing stress & overwhelm", icon: Icons.self_improvement),
      Option(id: 3, text: "Lack of motivation", icon: Icons.trending_up),
      Option(id: 4, text: "Not sure where to start", icon: Icons.help_outline),
    ],
  ),
  // Add more questions here...
];