// Default location: lib/models/message.dart
// Message model to represent chat messages in the application

enum MessageRole { user, assistant, system }

class Message {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final String? imageUrl;
  final String? thinkingContent;
  final int? promptTokens;
  final int? completionTokens;
  final double? cost;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.imageUrl,
    this.thinkingContent,
    this.promptTokens,
    this.completionTokens,
    this.cost,
  });

  /// Total tokens used for this message
  int get totalTokens => (promptTokens ?? 0) + (completionTokens ?? 0);

  /// Formatted cost string
  String get formattedCost {
    if (cost == null || cost == 0) return '';
    if (cost! < 0.0001) return '<\$0.0001';
    return '\$${cost!.toStringAsFixed(4)}';
  }

  // Convert Message instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.toString().split('.').last,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'thinkingContent': thinkingContent,
      'promptTokens': promptTokens,
      'completionTokens': completionTokens,
      'cost': cost,
    };
  }

  // Create Message instance from JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      role: MessageRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => MessageRole.user,
      ),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrl: json['imageUrl'] as String?,
      thinkingContent: json['thinkingContent'] as String?,
      promptTokens: json['promptTokens'] as int?,
      completionTokens: json['completionTokens'] as int?,
      cost: (json['cost'] as num?)?.toDouble(),
    );
  }

  // Create a copy of Message with updated fields
  Message copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    String? imageUrl,
    String? thinkingContent,
    int? promptTokens,
    int? completionTokens,
    double? cost,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      thinkingContent: thinkingContent ?? this.thinkingContent,
      promptTokens: promptTokens ?? this.promptTokens,
      completionTokens: completionTokens ?? this.completionTokens,
      cost: cost ?? this.cost,
    );
  }
}
