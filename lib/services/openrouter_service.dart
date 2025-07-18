// Default location: lib/services/openrouter_service.dart
// Service to handle OpenRouter API interactions

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import '../models/message.dart';
import '../models/bot.dart';
import '../services/network_service.dart';
import '../languages/languages.dart';
import '../settingsvariables/default_settings_variables.dart' as default_settings_variables;

// Constants for API configuration
const int _maxRetries = 3;
const Duration _retryDelay = Duration(seconds: 2);
const Duration _connectTimeout = Duration(seconds: 15);
const Duration _receiveTimeout = Duration(seconds: 60);
const Duration _sendTimeout = Duration(seconds: 30);
const Duration _requestTimeout = Duration(seconds: 10);
const Duration _testTimeout = Duration(seconds: 8);
const int _maxTokensForCheck = 5;
const double _testTemperature = 0.0;
const int _maxFileSize = 25 * 1024 * 1024; // 25MB in bytes

// Model constants, this is for testing the connection.
const int _titleMaxTokens = 128;
const int _titleMaxLength = 200;

// Request-related constants this is for openrouter activity panel
const String _contentType = 'application/json';
const String _httpReferer = 'https://github.com/bruhmomentumtr/flutterai';
const String _appTitle = 'FlutterAI Chat App';
const String _authorizationPrefix = 'Bearer ';

// Default models in case API fails (like no internet)
const List<String> _defaultModels = [
  Languages.defaultModelsMessage,
];

class OpenRouterService {
  late Dio _dio;
  int _chatCounter = 0;

  // Set chat counter
  void setChatCounter(int counter) {
    _chatCounter = counter;
  }

  // Initialize with API key
  void initialize(String apiKey) {
    if (apiKey.isEmpty) {
      debugPrint(Languages.warningEmptyApiKey);
      return;
    }

    default_settings_variables.apikey = apiKey;

    // Dio configuration
    _dio = Dio(BaseOptions(
        baseUrl: default_settings_variables.baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        headers: {
          'Content-Type': _contentType,
          'Authorization': '$_authorizationPrefix$default_settings_variables.apikey',
          'HTTP-Referer': _httpReferer,
          'X-Title': _appTitle,
        }));

    // Add retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            // Get retry count from request options
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;

            if (retryCount < _maxRetries) {
              debugPrint(
                  'Connection error: ${error.type}. Retrying (${retryCount + 1}/$_maxRetries)...');

              // Check internet connection
              final isConnected = await NetworkService.isConnected();
              if (!isConnected) {
                debugPrint(Languages.errorNoInternetRetryCancelled);
                return handler.next(error);
              }

              // Wait before retrying
              await Future.delayed(_retryDelay);

              // Retry request
              try {
                final options = error.requestOptions;
                options.extra['retryCount'] = retryCount + 1;

                final response = await _dio.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                    extra: options.extra,
                  ),
                );
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              debugPrint(Languages.errorMaxRetriesReached);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Check if API key is set
  bool get isInitialized => default_settings_variables.apikey.isNotEmpty;

  // Get available models from OpenRouter
  Future<List<String>> getAvailableModels() async {
    if (!isInitialized) {
      debugPrint(Languages.errorApiKeyNotInitializedFetchingModels);
      return _defaultModels;
    }

    // Check network connection
    final isConnected = await NetworkService.isConnected();
    if (!isConnected) {
      debugPrint(Languages.errorNoInternetFetchingModels);
      return _defaultModels;
    }

    try {
      // Add timeout
      final response = await _dio
          .get('$default_settings_variables.baseUrl/models')
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> models = response.data['data'];
        // Get all available models
        final availableModels =
            models.map((model) => model['id'].toString()).toList();

        // Sort the models alphabetically
        availableModels.sort();

        if (availableModels.isEmpty) {
          debugPrint(Languages.warningNoModelsFound);
          return _defaultModels;
        }

        return availableModels;
      } else {
        debugPrint('${Languages.apiErrorPrefix} ${response.statusCode}');
        return _defaultModels;
      }
    } on DioException catch (e) {
      debugPrint('${Languages.dioExceptionFetchingModels} ${e.type} - ${e.message}');
      return _defaultModels;
    } on TimeoutException catch (e) {
      debugPrint('${Languages.timeoutFetchingModels} $e');
      return _defaultModels;
    } catch (e) {
      debugPrint('${Languages.errorFetchingModels} $e');
      return _defaultModels;
    }
  }

  // Send a chat completion request to OpenRouter
  Future<Message?> generateChatResponse({
    required List<Message> messages,
    required Bot bot,
    required String systemPrompt,
    required double temperature,
    required int maxTokens,
    required String sessionId,
  }) async {
    if (!isInitialized) {
      debugPrint(Languages.errorApiKeyNotInitialized);
      return null;
    }

    try {
      // Check for images in messages
      bool hasImage = messages
          .any((msg) => msg.imageUrl != null && msg.role == MessageRole.user);

      // Prepare messages for API request
      final List<Map<String, dynamic>> messagesJson = [];

      // Add system message if provided
      if (systemPrompt.isNotEmpty) {
        messagesJson.add({'role': 'system', 'content': systemPrompt});
      }

      // Add user and assistant messages
      for (var message in messages) {
        try {
          if (message.imageUrl != null && message.role == MessageRole.user) {
            // Prepare message with image
            final List<Map<String, dynamic>> contentList = [];

            // Add text content if exists
            if (message.content.trim().isNotEmpty) {
              contentList.add({'type': 'text', 'text': message.content});
            }

            // Add image with base64 data
            contentList.add({
              'type': 'image_url',
              'image_url': {'url': message.imageUrl!, 'detail': 'auto'}
            });

            messagesJson.add({'role': 'user', 'content': contentList});
          } else {
            // Add regular text message
            messagesJson.add(message.toJson());
          }
        } catch (e) {
          debugPrint('${Languages.errorMessageFormatting} $e - ${message.id}');
          continue;
        }
      }

      // Use the selected bot's model
      String useModel = bot.model;
      debugPrint('${Languages.usingSelectedModel} $useModel');

      // Prepare the request payload
      final Map<String, dynamic> payload = {
        'model': useModel,
        'messages': messagesJson,
        'temperature': temperature,
        'max_tokens': maxTokens,
        'stream': false
      };

      debugPrint('${Languages.sendingApiRequest} $useModel');
      debugPrint('${Languages.requestPayload} ${jsonEncode(payload)}');

      // Send the request
      final response = await _dio.post(
        '/chat/completions',
        data: payload,
        options: Options(validateStatus: (status) => status! < 500, headers: {
          'Content-Type': _contentType,
          'Authorization': 'Bearer $default_settings_variables.apikey',
          'HTTP-Referer': _httpReferer,
          'X-Title': _appTitle,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];

        // Generate a title for the message
        final title =
            await generateTitleForMessage(content, useModel, temperature);

        // Create a new message with the response
        return Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: content,
          timestamp: DateTime.now(),
          title: title,
          sessionId: sessionId,
        );
      } else {
        debugPrint('${Languages.apiErrorPrefix} ${response.statusCode} - ${response.data}');
        // Check for rate limit error
        if (response.statusCode == 429) {
          final errorMessage = response.data.toString();
          return Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: MessageRole.assistant,
            content: '${Languages.errorRateLimitReached} ($errorMessage)',
            timestamp: DateTime.now(),
            title: '${Languages.chatTitle} ${_chatCounter}',
            sessionId: sessionId,
          );
        }
        throw Exception('${Languages.apiErrorPrefix} ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      debugPrint('${Languages.errorGeneratingChatResponse} $e');
      // Check if it's a rate limit error in the exception
      if (e.toString().contains('Rate limit exceeded')) {
        return Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: '${Languages.errorRateLimitReached} ($e)',
          timestamp: DateTime.now(),
          title: '${Languages.chatTitle} ${_chatCounter}',
          sessionId: sessionId,
        );
      }
      return null;
    }
  }

  // Generate a title for a message
  Future<String?> generateTitleForMessage(
      String messageContent, String model, double temperature) async {
    if (!isInitialized) {
      debugPrint(Languages.errorApiKeyNotInitialized);
      return null;
    }

    // Check network connection
    final isConnected = await NetworkService.isConnected();
    if (!isConnected) {
      debugPrint(Languages.errorNoInternetGeneratingTitle);
      return Languages.connectionErrorTitle;
    }

    try {
      // Keep only the first 200 characters for generating the title
      final trimmedContent = messageContent.length > _titleMaxLength
          ? '${messageContent.substring(0, _titleMaxLength)}...'
          : messageContent;

      // Create prompt for title generation
      final List<Map<String, dynamic>> messagesJson = [
        {
          'role': 'system',
          'content':
              '${Languages.generateShortDescriptiveTitle} ${Languages.titleShouldBeMaximum5Words}.',
        },
        {
          'role': 'user',
          'content': trimmedContent,
        }
      ];

      // Prepare request for title generation
      final Map<String, dynamic> payload = {
        'model': default_settings_variables.defaultControlModel,
        'messages': messagesJson,
        'temperature': temperature,
        'max_tokens': _titleMaxTokens,
      };

      // Send the request
      final response = await _dio.post(
        '$default_settings_variables.baseUrl/chat/completions',
        data: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String title = data['choices'][0]['message']['content'];

        // Clean up title (remove quotes and periods if present)
        title = title.replaceAll('"', '').replaceAll("'", "").trim();
        if (title.endsWith('.')) {
          title = title.substring(0, title.length - 1);
        }

        // If title is empty or only contains whitespace, generate numbered title
        if (title.isEmpty || title.trim().isEmpty) {
          return '${Languages.chatTitle} ${_chatCounter}';
        }

        return title;
      }
      return null;
    } catch (e) {
      debugPrint('${Languages.errorGeneratingTitle} $e');
      // Generate a numbered title when bot fails
      return '${Languages.chatTitle} ${_chatCounter}';
    }
  }

  // Test API connection
  Future<bool> testApiConnection() async {
    if (!isInitialized) {
      debugPrint(Languages.errorApiKeyNotInitializedForTest);
      return false;
    }

    try {
      // Create a simple test request - only 25 tokens
      final Map<String, dynamic> payload = {
        'model': default_settings_variables.defaultControlModel,
        'messages': [
          {'role': 'user', 'content': '${Languages.sayOkIfYouCanReadThis}.'}
        ],
        'max_tokens': _maxTokensForCheck,
        'temperature': _testTemperature,
      };

      // Send request with short timeout
      final response = await _dio
          .post(
            '$default_settings_variables.baseUrl/chat/completions',
            data: jsonEncode(payload),
          )
          .timeout(_testTimeout);

      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('${Languages.errorApiTestFailedDio} ${e.type} - ${e.message}');
      return false;
    } on TimeoutException catch (e) {
      debugPrint('${Languages.errorApiTestFailedTimeout} $e');
      return false;
    } catch (e) {
      debugPrint('${Languages.errorApiTestFailed} $e');
      return false;
    }
  }

  // Upload an image and return its data URL
  Future<String?> uploadImage(File imageFile) async {
    if (!isInitialized) {
      debugPrint(Languages.errorApiKeyNotInitialized);
      return null;
    }

    // Check network connection
    final isConnected = await NetworkService.isConnected();
    if (!isConnected) {
      debugPrint(Languages.errorNoInternetImageUpload);
      throw Exception(Languages.exceptionNoInternetImageUpload);
    }

    // Check if file exists and is readable
    if (!await imageFile.exists()) {
      debugPrint('${Languages.errorImageFileNotExist} ${imageFile.path}');
      throw Exception('${Languages.exceptionImageFileNotFound} ${path.basename(imageFile.path)}');
    }

    try {
      // Check file size (25MB maximum)
      final fileSize = await imageFile.length();
      if (fileSize > _maxFileSize) {
        debugPrint(Languages.errorImageSizeTooLarge);
        throw Exception(Languages.exceptionImageSizeTooLarge);
      }

      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Get file extension
      final fileExtension = path.extension(imageFile.path).toLowerCase();
      String mimeType;

      // Determine MIME type
      switch (fileExtension) {
        case '.jpg':
        case '.jpeg':
          mimeType = 'image/jpeg';
          break;
        case '.png':
          mimeType = 'image/png';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        case '.webp':
          mimeType = 'image/webp';
          break;
        default:
          mimeType = 'image/jpeg';
      }

      // Create base64 data URL with proper formatting
      final dataUrl = 'data:$mimeType;base64,$base64Image';
      debugPrint('${Languages.imageConvertedToBase64WithMimeType} $mimeType');
      return dataUrl;
    } catch (e) {
      debugPrint('${Languages.errorInUploadImage} $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('${Languages.unexpectedErrorUploadingImage} $e');
    }
  }
}
