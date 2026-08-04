import 'package:flutter_test/flutter_test.dart';
import 'package:openrouterapp/models/bot.dart';

void main() {
  group('Bot', () {
    test('fromJson parses pricing fields and toJson serializes them', () {
      final bot = Bot.fromJson({
        'id': '1',
        'name': 'Test Bot',
        'model': 'openai/gpt-4o-mini',
        'iconName': 'chat',
        'promptPrice': 0.15,
        'completionPrice': 0.60,
      });

      expect(bot.promptPrice, 0.15);
      expect(bot.completionPrice, 0.60);

      expect(bot.toJson(), {
        'id': '1',
        'name': 'Test Bot',
        'model': 'openai/gpt-4o-mini',
        'iconName': 'chat',
        'promptPrice': 0.15,
        'completionPrice': 0.6,
      });
    });

    test('copyWith updates and clears nullable pricing fields', () {
      const bot = Bot(
        id: '1',
        name: 'Test Bot',
        model: 'openai/gpt-4o-mini',
        iconName: 'chat',
        promptPrice: 0.15,
        completionPrice: 0.60,
      );

      final updated = bot.copyWith(promptPrice: 0.20);
      expect(updated.promptPrice, 0.20);
      expect(updated.completionPrice, 0.60);

      final cleared = updated.copyWith(completionPrice: null);
      expect(cleared.completionPrice, isNull);
    });

    test('formattedPricing returns formatted USD per 1M tokens', () {
      const bot = Bot(
        id: '1',
        name: 'Test Bot',
        model: 'openai/gpt-4o-mini',
        iconName: 'chat',
        promptPrice: 0.15,
        completionPrice: 0.60,
      );

      expect(
        bot.formattedPricing,
        'Prompt \$0.15 · Completion \$0.60 per 1M tokens',
      );
    });

    test('formattedPricing is null when no prices are available', () {
      const bot = Bot(
        id: '1',
        name: 'Test Bot',
        model: 'openai/gpt-4o-mini',
        iconName: 'chat',
      );

      expect(bot.formattedPricing, isNull);
    });
  });
}
