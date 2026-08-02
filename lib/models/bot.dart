// Default location: lib/models/bot.dart
// Bot model to represent different AI assistant configurations

class Bot {
  final String id;
  final String name;
  final String model; // OpenAI/OpenRouter model identifier (e.g., gpt-4o, anthropic/claude-3)
  final String? description;
  final String? systemPrompt;
  final double? temperature;
  final int? maxTokens;
  final String? iconName;
  final double? promptPrice; // USD per token
  final double? completionPrice; // USD per token

  const Bot({
    required this.id,
    required this.name,
    required this.model,
    this.description,
    this.systemPrompt,
    this.temperature,
    this.maxTokens,
    this.iconName,
    this.promptPrice,
    this.completionPrice,
  });

  /// Formatted pricing per 1M tokens (e.g. "$2.50 / $10.00 per 1M tkn")
  String get formattedPricing {
    if (promptPrice == null && completionPrice == null) return '';
    final promptPerM = (promptPrice ?? 0) * 1000000;
    final completionPerM = (completionPrice ?? 0) * 1000000;
    return '\$${promptPerM.toStringAsFixed(2)} / \$${completionPerM.toStringAsFixed(2)} per 1M tkn';
  }

  // Convert Bot instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'description': description,
      'systemPrompt': systemPrompt,
      'temperature': temperature,
      'maxTokens': maxTokens,
      'iconName': iconName,
      'promptPrice': promptPrice,
      'completionPrice': completionPrice,
    };
  }

  // Create Bot instance from JSON map
  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      description: json['description'] as String?,
      systemPrompt: json['systemPrompt'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: json['maxTokens'] as int?,
      iconName: json['iconName'] as String?,
      promptPrice: (json['promptPrice'] as num?)?.toDouble(),
      completionPrice: (json['completionPrice'] as num?)?.toDouble(),
    );
  }

  // Create a copy of Bot with updated fields
  Bot copyWith({
    String? id,
    String? name,
    String? model,
    String? description,
    String? systemPrompt,
    double? temperature,
    int? maxTokens,
    String? iconName,
    double? promptPrice,
    double? completionPrice,
  }) {
    return Bot(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      description: description ?? this.description,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      iconName: iconName ?? this.iconName,
      promptPrice: promptPrice ?? this.promptPrice,
      completionPrice: completionPrice ?? this.completionPrice,
    );
  }
}
