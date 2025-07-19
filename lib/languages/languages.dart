// Default location: lib/languages/languages.dart
// User-visible string constants for the entire application (English)
// Usage: Languages.textCancel, Languages.textDelete, etc.

class Languages {
  // services/openrouter_service.dart debug and user text messages
  static const String errorApiKeyNotInitialized = 'Error: API key not initialized';
  static const String warningEmptyApiKey = 'Warning: Attempted to initialize OpenRouterService with an empty API key';
  static const String errorApiKeyNotInitializedForTest = 'Error: API key not initialized for test';
  static const String errorApiKeyNotInitializedFetchingModels = 'Error: API key not initialized, returning default models';
  static const String errorNoInternetFetchingModels = 'Error: No internet connection when fetching models';
  static const String warningNoModelsFound = 'Warning: No models found, returning defaults';
  static const String errorFetchingModels = 'Error fetching models:';
  static const String dioExceptionFetchingModels = 'DioException fetching models:';
  static const String timeoutFetchingModels = 'Timeout fetching models:';
  static const String errorGeneratingChatResponse = 'Error generating chat response:';
  static const String apiErrorPrefix = 'API Error:';
  static const String errorRateLimitReached = 'Sorry, you have reached the daily usage limit. Please try again later.';
  static const String errorMessageFormatting = 'Message formatting error:';
  static const String errorGeneratingTitle = 'Error generating title:';
  static const String errorNoInternetGeneratingTitle = 'Error: No internet connection when generating title';
  static const String connectionErrorTitle = 'Connection Error';
  static const String errorApiTestFailedDio = 'API test failed (DioException):';
  static const String errorApiTestFailedTimeout = 'API test failed (Timeout):';
  static const String errorApiTestFailed = 'API test failed:';
  static const String errorNoInternetImageUpload = 'Error: No internet connection for image upload';
  static const String exceptionNoInternetImageUpload = 'No internet connection. Please check your connection and try again.';
  static const String errorImageFileNotExist = 'Error: Image file does not exist:';
  static const String exceptionImageFileNotFound = 'Image file not found:';
  static const String errorImageSizeTooLarge = 'Error: Image size exceeds 25MB limit';
  static const String exceptionImageSizeTooLarge = 'Image size too large (maximum 25MB).';
  static const String errorInUploadImage = 'Error in uploadImage:';
  static const String unexpectedErrorUploadingImage = 'Unexpected error while uploading image:';
  static const String defaultModelsMessage = 'Check your internet connection or your API key';

  // services/network_service.dart debug and user text messages
  static const String msgNoConnectivity = 'No connectivity:';
  static const String msgLookupTimeout = ' lookup timeout';
  static const String msgSuccessfullyConnected = 'Successfully connected to ';
  static const String msgFailedToConnect = 'Failed to connect to ';
  static const String msgTimeoutConnecting = 'Timeout connecting to ';
  static const String msgAllConnectivityTestsFailed = 'All connectivity tests failed';
  static const String msgInternetConnectionError = 'Internet connection error:';
  static const String msgTimeoutError = 'Timeout error:';
  static const String msgGeneralInternetConnectionError = 'General internet connection error:';

  // widgets/message_input.dart debug and user text messages
  static const String msgSelectedImageNotFound = 'Selected image not found.';
  static const String msgErrorPickingImage = 'An error occurred while selecting the image.';
  static const String msgTakenPhotoNotSaved = 'The taken photo could not be saved.';
  static const String msgErrorTakingPhoto = 'An error occurred while taking the photo.';
  static const String msgImageLoadError = 'Image loading error:';
  static const String msgImageNotLoaded = 'Image could not be loaded';
  static const String tooltipAddImage = 'Add Image';
  static const String tooltipTakePhoto = 'Take Photo';
  static const String hintTextMessage = 'Type a message...';

  // widgets/message_bubble.dart debug and user text messages
  static const String textCopyToClipboard = 'Open the menu to copy the text';
  static const String textMessageCopied = 'Message copied to clipboard';
  static const String textMessageCopyError = 'Error copying message';
  static const String textMessageEmpty = 'Message content is empty';
  static const String textRawTextCopied = 'Raw text copied to clipboard';
  static const String textRawTextCopyError = 'Error copying raw text';
  static const String textRawTextEmpty = 'Raw text to copy is empty';
  static const String textImageLoadError = 'Image could not be loaded';
  static const String textImageFormatError = 'Image format not supported';
  static const String textDeleteMessageTitle = 'Delete Message';
  static const String textDeleteMessageConfirm = 'Are you sure you want to delete this message?';
  static const String textCancel = 'Cancel'; // Use this everywhere for cancel
  static const String textDelete = 'Delete'; // Use this everywhere for delete
  static const String textShowProcessed = 'Show processed content';
  static const String textShowRaw = 'Show raw content';
  static const String textMoreOptions = 'More options';
  static const String textCopyMessage = 'Copy message';
  static const String textCopyRawText = 'Copy raw text';
  static const String textDeleteMessage = 'Delete message';

  // widgets/markdown_latex_extension.dart debug and user text messages
  static const String latexErrorDebug = 'LaTeX Error:';
  static const String errorRenderingLatex = 'Error rendering LaTeX:';
  static const String inlineLatexErrorDebug = 'Inline LaTeX Error:';
  static const String latexErrorWidget = 'LaTeX Error:';

  // widgets/bot_selection.dart debug and user text messages
  static const String labelSelectBot = 'Select a Bot';
  static const String labelAddNewBot = 'Add New Bot';
  static const String tooltipEditBot = 'Edit Bot';
  static const String labelTemp = 'Temp: ';
  static const String labelMax = 'Max: ';

  // widgets/bot_editor_dialog.dart debug and user text messages
  static const String titleCreateBot = 'Create New Bot';
  static const String titleEditBot = 'Edit Bot';
  static const String labelBotName = 'Bot Name';
  static const String hintBotName = 'Enter a name for your bot';
  static const String errorBotName = 'Please enter a bot name';
  static const String labelModel = 'Model';
  static const String labelSystemPrompt = 'System Prompt';
  static const String hintSystemPrompt = 'Enter instructions for the bot';
  static const String errorSystemPrompt = 'Please enter a system prompt';
  static const String labelTemperature = 'Temperature: ';
  static const String labelTemperatureHelp = 'Lower values = more precise, higher values = more creative';
  static const String labelMaxTokens = 'Max Tokens: ';
  static const String labelIcon = 'Icon:';
  static const String buttonCancel = 'Cancel';
  static const String buttonCreate = 'Create';
  static const String buttonUpdate = 'Update';

  // screens/welcome_screen.dart debug and user text messages
  static const String appTitle = 'OpenRouter Chat Application';
  static const String appSubtitle = 'Enter your OpenRouter API key to get started';
  static const String labelApiKey = 'OpenRouter API Key';
  static const String hintApiKey = 'sk-...';
  static const String apiKeyInfo = 'Your API key will be securely stored on your device and used only for communication with OpenRouter services.';
  static const String buttonContinue = 'Continue';
  static const String buttonSkip = 'Skip for now (for testing)';
  static const String errorEnterApiKey = 'Please enter a valid API key';
  static const String errorInvalidApiKey = 'Invalid API key format. OpenRouter keys must start with "sk-".';
  static const String successApiKeySaved = 'API key saved successfully';
  static const String msgEnterApiKey = 'Please enter your API key.';
  static const String msgInvalidApiKey = 'Invalid API key.';
  static const String msgApiKeySaved = 'API key saved.';


  // screens/settings_screen.dart debug and user text messages
  static const String textSettings = 'Settings'; // Use this everywhere for settings
  static const String textApiKey = 'API Key';
  static const String textApiKeyHint = 'Enter your OpenRouter API key';
  static const String textApiKeyError = 'API key cannot be empty';
  static const String textShowRawFormat = 'Show Raw Format (for latex)';
  static const String textShowRawFormatDesc = 'Show messages in raw format (for latex)';
  static const String textTemperature = 'Temperature';
  static const String textTemperatureDesc = 'Creativity level of responses (0.0 - 2.0)';
  static const String textMaxTokens = 'Maximum Tokens';
  static const String textMaxTokensDesc = 'Maximum number of tokens for responses';
  static const String textSystemPrompt = 'System Prompt';
  static const String textSystemPromptDesc = 'System prompt for the AI assistant';
  static const String textSave = 'Save';
  static const String textReset = 'Reset';
  static const String textResetConfirm = 'All settings will be reset to default values. Do you want to continue?';
  static const String textYes = 'Yes';
  static const String textNo = 'No';
  static const String errorTemperatureEmpty = 'Temperature value cannot be empty';
  static const String errorTemperatureRange = 'Temperature value must be between 0.0 and 2.0';
  static const String errorMaxTokensEmpty = 'Maximum token value cannot be empty';
  static const String errorMaxTokensPositive = 'Maximum token value must be a positive number';
    static const String msgManualTestButton = 'Test API Key';

  // screens/session_list_screen.dart debug and user text messages
  static const String titleDeleteSessions = 'Delete Sessions';
  static const String confirmDeleteSessions = 'Are you sure you want to delete the selected sessions?';
  static const String labelCancel = 'Cancel';
  static const String labelDelete = 'Delete';
  static const String labelSelectedSessions = 'sessions selected';
  static const String titleSessionList = 'Session List';
  static const String tooltipSelectAll = 'Select All';
  static const String tooltipDeleteSelected = 'Delete Selected';
  static const String tooltipDeleteSessions = 'Delete Sessions';
  static const String tooltipNewSession = 'New Session';
  static const String labelNoSessions = 'No sessions yet. Create a new session.';
  static const String labelNewSession = 'New Session';
  static const String titleDeleteSession = 'Delete Session';
  static const String confirmDeleteSession = 'Are you sure you want to delete this session?';
  static const String labelActive = 'Active';
  static const String labelYesterday = 'Yesterday';

  // screens/network_error_screen.dart debug and user text messages
  static const String textConnectionError = 'Connection Error';
  static const String textNoInternet = 'No internet connection found'; // Use this everywhere for no internet
  static const String textCheckConnection = 'An internet connection is required for the app to work. Please check your connection and try again.';
  static const String textChecking = 'Checking...';
  static const String textRetry = 'Retry'; // Use this everywhere for retry
  static const String textDiagnostics = 'Diagnostics:';

  // screens/chat_screen.dart debug and user text messages
  // Only keep one textNoInternet, textCancel, textDelete, textSettings, textRetry
  static const String textApiServiceUnavailable = 'API service is unavailable. Please check your internet connection and API key.';
  static const String textApiServiceError = 'Error while checking API service:';
  static const String textSessionList = 'Session List';
  static const String textClearChat = 'Clear Chat';
  static const String textClearChatConfirm = 'Are you sure you want to clear the entire chat history?';
  static const String textClear = 'Clear';
  static const String textApiKeyRequired = 'API Key Required';
  static const String textApiKeyRequiredDesc = 'Please define your OpenRouter API key in settings';
  static const String textSettingsButton = 'Settings';
  static const String textBotNotSelected = 'Bot Not Selected';
  static const String textSelectBotToStart = 'Select a bot to start chatting';
  static const String textSelectBot = 'Select Bot';
  static const String textNoMessages = 'No messages yet';
  static const String textSendMessageToStart = 'Send a message below to start the conversation';
  static const String textYourBots = 'Your Bots';
  static const String textAddNewBot = 'Add New Bot';
  static const String textNoBotsConfigured = 'No bots configured yet';
  static const String textAddBotToStart = 'Add a new bot to start chatting';
  static const String textDeleteBot = 'Delete Bot';
  static const String textDeleteBotConfirm = 'Are you sure you want to delete';
  static const String textLoadingModels = 'Loading available models...';
  static const String textErrorLoadingModels = 'Error loading models:';
  static const String textBotEditCancel = 'Cancel';
  static const String textOpenRouterChat = 'OpenRouter Chat';
  static const String textSetApiKeyForBots = 'Please set an API key in settings before creating or editing bots.';

  // providers/settings_provider.dart debug and user text messages
  static const String msgErrorLoadingSettings = 'Error loading settings:';
  static const String msgErrorSavingSettings = 'Error saving settings:';
  static const String themeModeDark = 'dark';
  static const String themeModeLight = 'light';
  static const String msgEndpointSuccess = 'Success! Using endpoint: ';
  static const String msgEndpointFail = 'Could not connect to any endpoint.';

  // providers/chat_provider.dart debug and user text messages
  static const String msgErrorLoadingSessions = 'Error loading sessions:';
  static const String msgErrorSavingSessions = 'Error saving sessions:';
  static const String msgPleaseSelectBot = 'Please select a bot first';
  static const String msgImageUploadFailed = 'Image upload failed';
  static const String msgErrorSendingMessage = 'Error sending message:';
  static const String msgErrorWhileSending = 'An error occurred while sending the message';
  static const String msgThinking = 'Thinking...';
  static const String msgFailedToGenerateResponse = 'Failed to generate response';
  static const String msgErrorGeneratingResponse = 'Error generating response:';

  // providers/bot_provider.dart user-visible string constants
  static const String msgErrorInitializingBots = 'Error initializing bots:';
  static const String msgErrorSavingBots = 'Error saving bots:';
  static const String msgBotNotFound = 'Bot not found';
  static const String msgBotName = 'Bots';

  // main.dart user-visible string constants
  static const String msgCheckingConnection = 'Checking connection...';
  static const String msgConnectionErrorDebug = 'Connection check error: ';
  static const String appTitleMain = 'OpenRouter Chat';

  // openrouter_service.dart
  static const String errorNoInternetRetryCancelled = 'No internet connection, retry cancelled.';
  static const String errorMaxRetriesReached = 'Max retries reached. Giving up.';
  static const String usingSelectedModel = 'Using selected model:';
  static const String sendingApiRequest = 'Sending API request with model:';
  static const String requestPayload = 'Request payload:';
  static const String chatTitle = 'Chat';
  static const String generateShortDescriptiveTitle = 'Generate a short and descriptive title for the following content.';
  static const String titleShouldBeMaximum5Words = 'Title should be maximum 5 words';
  static const String sayOkIfYouCanReadThis = 'Say "OK" if you can read this'; // this is for the bot connection test message
  static const String imageConvertedToBase64WithMimeType = 'Image converted to base64 with MIME type:';
  
}
