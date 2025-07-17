// Default location: lib/languages/languages.dart
// Uygulama genelinde kullanıcıya gösterilen mesaj sabitleri
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
  static const String errorRateLimitReached = 'Üzgünüm, günlük kullanım limitine ulaştınız. Lütfen daha sonra tekrar deneyin.';
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
  static const String defaultModelsMessage = 'internet bağlantınızı kontrol edin veya api anahtarınızı kontrol edin';

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
  static const String msgSelectedImageNotFound = 'Seçilen görsel bulunamadı.';
  static const String msgErrorPickingImage = 'Görsel seçilirken bir hata oluştu.';
  static const String msgTakenPhotoNotSaved = 'Çekilen fotoğraf kaydedilemedi.';
  static const String msgErrorTakingPhoto = 'Fotoğraf çekilirken bir hata oluştu.';
  static const String msgImageLoadError = 'Görsel yükleme hatası:';
  static const String msgImageNotLoaded = 'Görsel yüklenemedi';
  static const String tooltipAddImage = 'Görsel Ekle';
  static const String tooltipTakePhoto = 'Fotoğraf Çek';
  static const String hintTextMessage = 'Mesaj yazın...';

  // widgets/message_bubble.dart debug and user text messages
  static const String textCopyToClipboard = 'Metni kopyalamak için menüyü açın';
  static const String textMessageCopied = 'Mesaj panoya kopyalandı';
  static const String textMessageCopyError = 'Mesaj kopyalanırken hata oluştu';
  static const String textMessageEmpty = 'Kopyalanacak mesaj içeriği boş';
  static const String textRawTextCopied = 'Ham metin panoya kopyalandı';
  static const String textRawTextCopyError = 'Ham metin kopyalanırken hata oluştu';
  static const String textRawTextEmpty = 'Kopyalanacak ham metin boş';
  static const String textImageLoadError = 'Görsel yüklenemedi';
  static const String textImageFormatError = 'Görsel formatı desteklenmiyor';
  static const String textDeleteMessageTitle = 'Mesajı Sil';
  static const String textDeleteMessageConfirm = 'Bu mesajı silmek istediğinizden emin misiniz?';
  static const String textCancel = 'İptal'; // Use this everywhere for cancel
  static const String textDelete = 'Sil'; // Use this everywhere for delete
  static const String textShowProcessed = 'İşlenmiş içeriği göster';
  static const String textShowRaw = 'Ham içeriği göster';
  static const String textMoreOptions = 'Daha fazla seçenek';
  static const String textCopyMessage = 'Mesajı kopyala';
  static const String textCopyRawText = 'Ham metni kopyala';
  static const String textDeleteMessage = 'Mesajı sil';

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
  static const String appTitle = 'OpenRouter Sohbet Uygulaması';
  static const String appSubtitle = 'Başlamak için OpenRouter API anahtarını girin';
  static const String labelApiKey = 'OpenRouter API Anahtarı';
  static const String hintApiKey = 'sk-...';
  static const String apiKeyInfo = 'API anahtarınız cihazınızda güvenli bir şekilde saklanacak ve sadece OpenRouter servisleriyle iletişim için kullanılacaktır.';
  static const String buttonContinue = 'Devam Et';
  static const String buttonSkip = 'Şimdilik Atla (Test için)';
  static const String errorEnterApiKey = 'Lütfen geçerli bir API anahtarı girin';
  static const String errorInvalidApiKey = 'Geçersiz API anahtarı formatı. OpenRouter anahtarları "sk-" ile başlamalıdır.';
  static const String successApiKeySaved = 'API anahtarı başarıyla kaydedildi';

  // screens/settings_screen.dart debug and user text messages
  static const String textSettings = 'Ayarlar'; // Use this everywhere for settings
  static const String textApiKey = 'API Anahtarı';
  static const String textApiKeyHint = 'OpenRouter API anahtarınızı girin';
  static const String textApiKeyError = 'API anahtarı boş olamaz';
  static const String textShowRawFormat = 'Ham Formatı Göster';
  static const String textShowRawFormatDesc = 'Mesajları ham formatında göster';
  static const String textTemperature = 'Sıcaklık';
  static const String textTemperatureDesc = 'Yanıtların yaratıcılık seviyesi (0.0 - 2.0)';
  static const String textMaxTokens = 'Maksimum Token';
  static const String textMaxTokensDesc = 'Yanıtlar için maksimum token sayısı';
  static const String textSystemPrompt = 'Sistem Promptu';
  static const String textSystemPromptDesc = 'AI asistanı için sistem promptu';
  static const String textSave = 'Kaydet';
  static const String textReset = 'Sıfırla';
  static const String textResetConfirm = 'Tüm ayarlar varsayılan değerlerine sıfırlanacak. Devam etmek istiyor musunuz?';
  static const String textYes = 'Evet';
  static const String textNo = 'Hayır';
  static const String errorTemperatureEmpty = 'Sıcaklık değeri boş olamaz';
  static const String errorTemperatureRange = 'Sıcaklık değeri 0.0 ile 2.0 arasında olmalıdır';
  static const String errorMaxTokensEmpty = 'Maksimum token değeri boş olamaz';
  static const String errorMaxTokensPositive = 'Maksimum token değeri pozitif bir sayı olmalıdır';

  // screens/session_list_screen.dart debug and user text messages
  static const String titleDeleteSessions = 'Sohbetleri Sil';
  static const String confirmDeleteSessions = 'sohbeti silmek istediğinizden emin misiniz?';
  static const String labelCancel = 'İptal';
  static const String labelDelete = 'Sil';
  static const String labelSelectedSessions = 'sohbet seçildi';
  static const String titleSessionList = 'Sohbet Listesi';
  static const String tooltipSelectAll = 'Tümünü Seç';
  static const String tooltipDeleteSelected = 'Seçilenleri Sil';
  static const String tooltipDeleteSessions = 'Sohbetleri Sil';
  static const String tooltipNewSession = 'Yeni Sohbet';
  static const String labelNoSessions = 'Henüz hiç sohbet yok. Yeni bir sohbet oluşturun.';
  static const String labelNewSession = 'Yeni Sohbet';
  static const String titleDeleteSession = 'Sohbeti Sil';
  static const String confirmDeleteSession = 'Bu sohbeti silmek istediğinizden emin misiniz?';
  static const String labelActive = 'Aktif';
  static const String labelYesterday = 'Dün';

  // screens/network_error_screen.dart debug and user text messages
  static const String textConnectionError = 'Bağlantı Hatası';
  static const String textNoInternet = 'İnternet bağlantısı bulunamadı'; // Use this everywhere for no internet
  static const String textCheckConnection = 'Uygulamanın çalışması için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.';
  static const String textChecking = 'Kontrol ediliyor...';
  static const String textRetry = 'Tekrar Dene'; // Use this everywhere for retry
  static const String textDiagnostics = 'Tanı Bilgileri:';

  // screens/chat_screen.dart debug and user text messages
  // Only keep one textNoInternet, textCancel, textDelete, textSettings, textRetry
  static const String textApiServiceUnavailable = 'API servisine erişilemiyor. Lütfen internet bağlantınızı ve API anahtarınızı kontrol edin.';
  static const String textApiServiceError = 'API servisi kontrolü sırasında hata:';
  static const String textSessionList = 'Sohbet Listesi';
  static const String textClearChat = 'Sohbeti Temizle';
  static const String textClearChatConfirm = 'Tüm mesajlaşma geçmişini silmek istediğinizden emin misiniz?';
  static const String textClear = 'Temizle';
  static const String textApiKeyRequired = 'API Anahtarı Gerekli';
  static const String textApiKeyRequiredDesc = 'Lütfen ayarlardan OpenRouter API anahtarınızı tanımlayın';
  static const String textSettingsButton = 'Ayarlar';
  static const String textBotNotSelected = 'Bot Seçilmedi';
  static const String textSelectBotToStart = 'Sohbete başlamak için bir bot seçin';
  static const String textSelectBot = 'Bot Seç';
  static const String textNoMessages = 'Henüz mesaj yok';
  static const String textSendMessageToStart = 'Konuşmaya başlamak için aşağıdan mesaj gönderin';
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

  // providers/chat_provider.dart debug and user text messages
  static const String msgErrorLoadingSessions = 'Error loading sessions:';
  static const String msgErrorSavingSessions = 'Error saving sessions:';
  static const String msgPleaseSelectBot = 'Please select a bot first';
  static const String msgImageUploadFailed = 'Görsel yükleme başarısız oldu';
  static const String msgErrorSendingMessage = 'Error sending message:';
  static const String msgErrorWhileSending = 'Mesaj gönderilirken bir hata oluştu';
  static const String msgThinking = 'Düşünüyor...';
  static const String msgFailedToGenerateResponse = 'Failed to generate response';
  static const String msgErrorGeneratingResponse = 'Error generating response:';

  // providers/bot_provider.dart user-visible string constants
  static const String msgErrorInitializingBots = 'Error initializing bots:';
  static const String msgErrorSavingBots = 'Error saving bots:';
  static const String msgBotNotFound = 'Bot not found';
  static const String msgBotName = 'Bots';

  // main.dart user-visible string constants
  static const String msgCheckingConnection = 'Bağlantı kontrol ediliyor...';
  static const String msgConnectionErrorDebug = 'Bağlantı kontrol hatası: ';
  static const String appTitleMain = 'OpenRouter Chat';
}
