import 'package:flutter_test/flutter_test.dart';
import 'package:openrouterapp/models/message.dart';

void main() {
  group('Message', () {
    test('fromJson parses token and cost fields', () {
      final message = Message.fromJson({
        'id': '1',
        'role': 'assistant',
        'content': 'Hello',
        'timestamp': 1234567890,
        'sessionId': 'session-1',
        'prompt_tokens': 12,
        'completionTokens': 34,
        'cost': 0.0015,
      });

      expect(message.promptTokens, 12);
      expect(message.completionTokens, 34);
      expect(message.cost, 0.0015);
    });

    test('toJson serializes token and cost fields', () {
      final message = Message(
        id: '1',
        role: MessageRole.assistant,
        content: 'Hello',
        timestamp: DateTime.fromMillisecondsSinceEpoch(1234567890),
        sessionId: 'session-1',
        promptTokens: 12,
        completionTokens: 34,
        cost: 0.0015,
      );

      expect(message.toJson()['promptTokens'], 12);
      expect(message.toJson()['completionTokens'], 34);
      expect(message.toJson()['cost'], 0.0015);
    });

    test('copyWith updates and clears nullable token and cost fields', () {
      final message = Message(
        id: '1',
        role: MessageRole.assistant,
        content: 'Hello',
        timestamp: DateTime.now(),
        sessionId: 'session-1',
        promptTokens: 12,
        completionTokens: 34,
        cost: 0.0015,
      );

      final updated = message.copyWith(promptTokens: 20, cost: 0.0025);
      expect(updated.promptTokens, 20);
      expect(updated.completionTokens, 34);
      expect(updated.cost, 0.0025);

      final cleared = updated.copyWith(completionTokens: null, cost: null);
      expect(cleared.completionTokens, isNull);
      expect(cleared.cost, isNull);
    });

    test('totalTokens and formattedCost return expected values', () {
      final message = Message(
        id: '1',
        role: MessageRole.assistant,
        content: 'Hello',
        timestamp: DateTime.now(),
        sessionId: 'session-1',
        promptTokens: 12,
        completionTokens: 34,
        cost: 0.0015,
      );

      expect(message.totalTokens, 46);
      expect(message.formattedCost, '\$0.001500');
    });

    test('totalTokens and formattedCost are null when no data is present', () {
      final message = Message(
        id: '1',
        role: MessageRole.assistant,
        content: 'Hello',
        timestamp: DateTime.now(),
        sessionId: 'session-1',
      );

      expect(message.totalTokens, isNull);
      expect(message.formattedCost, isNull);
    });
  });
}
