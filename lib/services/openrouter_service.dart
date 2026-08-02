// Default location: lib/services/openrouter_service.dart
// Service to handle OpenRouter API interactions

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../models/bot.dart';
import '../services/network_service.dart';
import '../languages/languages.dart';

class OpenRouterService {
  late Dio _dio;
  String? _apiKey;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  OpenRouterService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://openrouter.ai/api/v1',
        headers: {
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://github.com/bruhmomentumtr/flutterai',
          'X-Title': 'FlutterAI',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  // Initialize service with API key
  void init(String apiKey) {
    if (apiKey.isEmpty) {
      _isInitialized = false;
      return;
    }
    _apiKey = apiKey;
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    _isInitialized = true;
  }

  // Alias for init
  void initialize(String apiKey) => init(apiKey);

  // Get available bots/models with pricing from OpenRouter
  Future<List<Bot>> getAvailableBotsWithPricing() async {
    if (!_isInitialized || _apiKey == null || _apiKey!.isEmpty) {
      return [];
    }

    try {
      final isConnected = await NetworkService.isConnected();
      if (!isConnected) {
        return [];
      }

      final response = await _dio.get('/models');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((item) {
          final id = item['id'] as String;
          final name = item['name'] as String? ?? id;
          final description = item['description'] as String?;
          final pricing = item['pricing'] as Map<String, dynamic>?;

          final double? promptPrice =
              double.tryParse(pricing?['prompt']?.toString() ?? '');
          final double? completionPrice =
              double.tryParse(pricing?['completion']?.toString() ?? '');

          return Bot(
            id: id,
            name: name,
            model: id,
            description: description,
            promptPrice: promptPrice,
            completionPrice: completionPrice,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching models with pricing: $e');
    }
    return [];
  }

  // Legacy string model list
  Future<List<String>> getAvailableModels() async {
    final bots = await getAvailableBotsWithPricing();
    if (bots.isNotEmpty) {
      return bots.map((b) => b.model).toList();
    }
    return ['openai/gpt-4o-mini', 'openai/gpt-4o', 'anthropic/claude-3.5-sonnet'];
  }

  // Send message to OpenRouter API and return response Message
  Future<Message> sendMessage({
    required String prompt,
    required Bot bot,
    List<Message> history = const [],
    String? imageUrl,
    double? temperature,
    int? maxTokens,
  }) async {
    if (!_isInitialized || _apiKey == null) {
      throw Exception(Languages.errorApiKeyNotInitialized);
    }

    final isConnected = await NetworkService.isConnected();
    if (!isConnected) {
      throw Exception(Languages.errorNetworkConnection);
    }

    final messages = <Map<String, dynamic>>[];

    if (bot.systemPrompt != null && bot.systemPrompt!.isNotEmpty) {
      messages.add({
        'role': 'system',
        'content': bot.systemPrompt,
      });
    }

    for (final msg in history) {
      messages.add({
        'role': msg.role.toString().split('.').last,
        'content': msg.content,
      });
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      messages.add({
        'role': 'user',
        'content': [
          {'type': 'text', 'text': prompt},
          {
            'type': 'image_url',
            'image_url': {'url': imageUrl}
          }
        ]
      });
    } else {
      messages.add({
        'role': 'user',
        'content': prompt,
      });
    }

    final requestBody = {
      'model': bot.model,
      'messages': messages,
      if (temperature != null || bot.temperature != null)
        'temperature': temperature ?? bot.temperature,
      if (maxTokens != null || bot.maxTokens != null)
        'max_tokens': maxTokens ?? bot.maxTokens,
    };

    try {
      final response = await _dio.post('/chat/completions', data: requestBody);

      if (response.statusCode == 200 && response.data != null) {
        final choices = response.data['choices'] as List?;
        if (choices == null || choices.isEmpty) {
          throw Exception('API returned empty choices');
        }

        final content = choices[0]['message']['content'] as String? ?? '';
        final usage = response.data['usage'] as Map<String, dynamic>?;

        int? promptTokens;
        int? completionTokens;
        double? cost;

        if (usage != null) {
          promptTokens = usage['prompt_tokens'] as int?;
          completionTokens = usage['completion_tokens'] as int?;

          if (promptTokens != null && completionTokens != null) {
            final pPrice = bot.promptPrice ?? 0.0;
            final cPrice = bot.completionPrice ?? 0.0;
            cost = (promptTokens * pPrice) + (completionTokens * cPrice);
          }
        }

        return Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: content,
          timestamp: DateTime.now(),
          promptTokens: promptTokens,
          completionTokens: completionTokens,
          cost: cost,
        );
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(Languages.errorApiKeyNotInitialized);
      }
      throw Exception('${Languages.errorNetworkConnection}: ${e.message}');
    }
  }
}
