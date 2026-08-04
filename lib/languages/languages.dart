// Default location: lib/languages/languages.dart
// User-visible string constants for the entire application (English)

class Languages {
  static const String appTitleMain = 'FlutterAI';
  static const String appSubtitle = 'Your AI Conversational Assistant';

  // services/openrouter_service.dart debug and user text messages
  static const String errorApiKeyNotInitialized =
      'Error: API key not initialized';
  static const String warningEmptyApiKey =
      'Warning: Attempted to initialize OpenRouterService with an empty API key';
  static const String errorApiKeyNotInitializedForTest =
      'Error: API key not initialized for test';
  static const String errorApiKeyNotInitializedFetchingModels =
      'Error: API key not initialized, returning default models';
  static const String errorNoInternetFetchingModels =
      'Error: No internet connection when fetching models';
  static const String errorNetworkConnection =
      'Error: Network connection failed';

  // providers/settings_provider.dart
  static const String msgErrorLoadingSettings = 'Error loading settings';
  static const String msgErrorSavingSettings = 'Error saving settings';

  // providers/bot_provider.dart
  static const String msgErrorLoadingBots = 'Error loading bots';
  static const String msgErrorSavingBots = 'Error saving bots';

  // providers/chat_provider.dart
  static const String msgPleaseSelectBot = 'Please select a bot';

  // welcome_screen.dart & settings_screen.dart
  static const String labelApiKey = 'API Key';
  static const String hintApiKey = 'Enter your OpenRouter or OpenAI API key';
  static const String apiKeyInfo =
      'Your API key is stored securely on your device.';
  static const String buttonContinue = 'Continue';
  static const String buttonSkip = 'Skip';
  static const String errorEnterApiKey = 'Please enter an API key';
  static const String errorInvalidApiKey = 'Invalid API key format';
  static const String successApiKeySaved = 'API key saved successfully';

  // bot_editor_dialog.dart
  static const String titleCreateBot = 'Create Bot';
  static const String titleEditBot = 'Edit Bot';
  static const String labelBotName = 'Bot Name';
  static const String hintBotName = 'Enter bot name';
  static const String errorBotName = 'Please enter a bot name';
  static const String labelModel = 'Model';
  static const String labelSystemPrompt = 'System Prompt';
  static const String hintSystemPrompt = 'Enter system instructions';
  static const String errorSystemPrompt = 'Please enter a system prompt';
  static const String labelTemperature = 'Temperature: ';
  static const String labelTemperatureHelp =
      'Higher values produce creative responses.';
  static const String labelMaxTokens = 'Max Tokens: ';
  static const String labelIcon = 'Icon';
  static const String buttonCancel = 'Cancel';
  static const String buttonCreate = 'Create';
  static const String buttonUpdate = 'Update';

  // widgets/bot_selection.dart
  static const String labelSelectBot = 'Select Bot';

  // widgets/message_input.dart
  static const String msgSelectedImageNotFound =
      'Selected image file not found';
  static const String msgImageLoadError = 'Error loading image';
  static const String msgErrorPickingImage = 'Error selecting image';
  static const String msgTakenPhotoNotSaved = 'Taken photo not saved';
  static const String msgErrorTakingPhoto = 'Error taking photo';
  static const String msgImageNotLoaded = 'Image could not be loaded';
  static const String tooltipAddImage = 'Add Image';
  static const String hintTextMessage = 'Type a message...';

  // widgets/markdown_latex_extension.dart
  static const String latexErrorWidget = 'Cannot render LaTeX';
  static const String latexErrorDebug = 'LaTeX render error';
  static const String inlineLatexErrorDebug = 'Inline LaTeX render error';

  // screens/chat_screen.dart
  static const String textSelectBotToStart = 'Select a bot to start chatting';
  static const String textSelectBot = 'Select Bot';
  static const String textNoMessages = 'No messages yet';
  static const String textSendMessageToStart =
      'Send a message below to start the conversation';
  static const String textYourBots = 'Your Bots';
  static const String textAddNewBot = 'Add New Bot';
  static const String textNoBotsConfigured = 'No bots configured yet';
  static const String errorRenderingLatex = 'Error rendering LaTeX';

  // screens/settings_screen.dart
  static const String textSettings = 'Settings';
  static const String textSave = 'Save';
  static const String textReset = 'Reset';
  static const String textResetConfirm = 'Reset all settings to defaults?';
  static const String textYes = 'Yes';
  static const String textNo = 'No';
  static const String textApiKey = 'API Key';
  static const String textApiKeyHint =
      'Enter your OpenRouter or OpenAI API key';
  static const String textApiKeyError = 'API key cannot be empty';
  static const String textTemperature = 'Temperature';
  static const String textTemperatureDesc =
      'Higher values produce creative responses.';
  static const String textMaxTokens = 'Max Tokens';
  static const String textMaxTokensDesc =
      'Maximum tokens for the model response.';
  static const String textSystemPrompt = 'System Prompt';
  static const String textSystemPromptDesc =
      'Instructions sent to the model before the conversation.';
  static const String errorMaxTokensEmpty = 'Please enter max tokens';
  static const String errorMaxTokensPositive =
      'Max tokens must be a positive number';
  static const String textShowRawFormat = 'Show raw format';
  static const String textShowRawFormatDesc =
      'Disable markdown and LaTeX rendering.';

  // screens/network_error_screen.dart
  static const String textConnectionError = 'Connection error';
  static const String textNoInternet = 'No internet connection';
  static const String textCheckConnection =
      'Please check your network and try again.';
  static const String textChecking = 'Checking...';
  static const String textRetry = 'Retry';

  // screens/session_list_screen.dart
  static const String titleSessionList = 'Sessions';
  static const String labelNoSessions = 'No sessions yet';
  static const String labelNewSession = 'New session';
  static const String labelSelectedSessions = 'selected';
  static const String titleDeleteSession = 'Delete session';
  static const String titleDeleteSessions = 'Delete sessions';
  static const String confirmDeleteSession =
      'Are you sure you want to delete this session?';
  static const String confirmDeleteSessions =
      'sessions will be deleted. Continue?';
  static const String tooltipSelectAll = 'Select all';
  static const String tooltipDeleteSelected = 'Delete selected';
  static const String tooltipDeleteSessions = 'Delete sessions';
  static const String labelDelete = 'Delete';
  static const String labelCancel = 'Cancel';
  static const String labelYesterday = 'Yesterday';

  // bot_editor_dialog.dart
  static const String errorSystemPromptRequired =
      'Please enter a system prompt';
}
