// Default location: lib/models/bot.dart
// Bot model to represent different AI assistant configurations

class Bot {
  static const Object _unset = Object();

  final String id;
  final String name;
  final String model; // OpenAI model identifier (e.g., gpt-4o, gpt-3.5-turbo)
  final String iconName;
  final double? promptPrice;
  final double? completionPrice;

  Bot({
    required this.id,
    required this.name,
    required this.model,
    required this.iconName,
    this.promptPrice,
    this.completionPrice,
  });

  String? get formattedPricing {
    if (promptPrice == null && completionPrice == null) {
      return null;
    }

    final pricingParts = <String>[];

    if (promptPrice != null) {
      pricingParts.add('Prompt \$${promptPrice!.toStringAsFixed(2)}');
    }

    if (completionPrice != null) {
      pricingParts.add('Completion \$${completionPrice!.toStringAsFixed(2)}');
    }

    return '${pricingParts.join(' · ')} per 1M tokens';
  }

  // Create a copy of the bot with updated values
  Bot copyWith({
    String? id,
    String? name,
    String? model,
    String? iconName,
    Object? promptPrice = _unset,
    Object? completionPrice = _unset,
  }) {
    return Bot(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      iconName: iconName ?? this.iconName,
      promptPrice: identical(promptPrice, _unset)
          ? this.promptPrice
          : promptPrice as double?,
      completionPrice: identical(completionPrice, _unset)
          ? this.completionPrice
          : completionPrice as double?,
    );
  }

  // Convert Bot to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'iconName': iconName,
      'promptPrice': promptPrice,
      'completionPrice': completionPrice,
    };
  }

  // Create a Bot from stored JSON
  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      iconName: json['iconName'],
      promptPrice: (json['promptPrice'] as num?)?.toDouble(),
      completionPrice: (json['completionPrice'] as num?)?.toDouble(),
    );
  }
}
