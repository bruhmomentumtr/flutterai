// Default location: lib/languages/languages.dart
// User-visible string constants for the entire application (English)

class Languages {
  static const String appTitleMain = 'FlutterAI';

  // services/openrouter_service.dart debug and user text messages
  static const String errorApiKeyNotInitialized = 'Error: API key not initialized';
  static const String warningEmptyApiKey = 'Warning: Attempted to initialize OpenRouterService with an empty API key';
  static const String errorApiKeyNotInitializedForTest = 'Error: API key not initialized for test';
  static const String errorApiKeyNotInitializedFetchingModels = 'Error: API key not initialized, returning default models';
  static const String errorNoInternetFetchingModels = 'Error: No internet connection when fetching models';
  static const String errorNetworkConnection = 'Error: Network connection failed';

  // providers/bot_provider.dart
  static const String msgErrorLoadingBots = 'Error loading bots';
  static const String msgErrorSavingBots = 'Error saving bots';

  // providers/chat_provider.dart
  static const String msgPleaseSelectBot = 'Please select a bot';

  // widgets/bot_selection.dart
  static const String labelSelectBot = 'Select Bot';

  // screens/chat_screen.dart
  static const String textSelectBotToStart = 'Select a bot to start chatting';
  static const String textSelectBot = 'Select Bot';
  static const String textNoMessages = 'No messages yet';
  static const String textSendMessageToStart = 'Send a message below to start the conversation';
  static const String textYourBots = 'Your Bots';
  static const String textAddNewBot = 'Add New Bot';
  static const String textNoBotsConfigured = 'No bots configured yet';
  static const String errorRenderingLatex = 'Error rendering LaTeX';
}
