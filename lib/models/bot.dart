// Default location: lib/models/bot.dart
// Bot model to represent different AI assistant configurations

class Bot {
  final String id;
  final String name;
  final String model; // OpenAI model identifier (e.g., gpt-4o, gpt-3.5-turbo)
  final String iconName;

  Bot({
    required this.id,
    required this.name,
    required this.model,
    required this.iconName,
  });

  // Create a copy of the bot with updated values
  Bot copyWith({
    String? id,
    String? name,
    String? model,
    String? iconName,
  }) {
    return Bot(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      iconName: iconName ?? this.iconName,
    );
  }

  // Convert Bot to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'iconName': iconName,
    };
  }

  // Create a Bot from stored JSON
  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      iconName: json['iconName'],
    );
  }
} 