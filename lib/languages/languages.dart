// Default location: lib/languages/languages.dart
// Uygulama genelinde kullanıcıya gösterilen mesaj sabitleri
// change this variables to your language

// services/openrouter_service.dart debug and user text messages
const String errorApiKeyNotInitialized = 'Error: API key not initialized';
const String warningEmptyApiKey = 'Warning: Attempted to initialize OpenRouterService with an empty API key';
const String errorApiKeyNotInitializedForTest = 'Error: API key not initialized for test';
const String errorApiKeyNotInitializedFetchingModels = 'Error: API key not initialized, returning default models';
const String errorNoInternetFetchingModels = 'Error: No internet connection when fetching models';
const String warningNoModelsFound = 'Warning: No models found, returning defaults';
const String errorFetchingModels = 'Error fetching models:';
const String dioExceptionFetchingModels = 'DioException fetching models:';
const String timeoutFetchingModels = 'Timeout fetching models:';
const String errorGeneratingChatResponse = 'Error generating chat response:';
const String apiErrorPrefix = 'API Error:';
const String errorRateLimitReached = 'Üzgünüm, günlük kullanım limitine ulaştınız. Lütfen daha sonra tekrar deneyin.';
const String errorMessageFormatting = 'Message formatting error:';
const String errorGeneratingTitle = 'Error generating title:';
const String errorNoInternetGeneratingTitle = 'Error: No internet connection when generating title';
const String connectionErrorTitle = 'Connection Error';
const String errorApiTestFailedDio = 'API test failed (DioException):';
const String errorApiTestFailedTimeout = 'API test failed (Timeout):';
const String errorApiTestFailed = 'API test failed:';
const String errorNoInternetImageUpload = 'Error: No internet connection for image upload';
const String exceptionNoInternetImageUpload = 'No internet connection. Please check your connection and try again.';
const String errorImageFileNotExist = 'Error: Image file does not exist:';
const String exceptionImageFileNotFound = 'Image file not found:';
const String errorImageSizeTooLarge = 'Error: Image size exceeds 25MB limit';
const String exceptionImageSizeTooLarge = 'Image size too large (maximum 25MB).';
const String errorInUploadImage = 'Error in uploadImage:';
const String unexpectedErrorUploadingImage = 'Unexpected error while uploading image:';
const String defaultModelsMessage = 'internet bağlantınızı kontrol edin veya api anahtarınızı kontrol edin';

// services/network_service.dart debug and user text messages
const String msgNoConnectivity = 'No connectivity:';
const String msgLookupTimeout = ' lookup timeout';
const String msgSuccessfullyConnected = 'Successfully connected to ';
const String msgFailedToConnect = 'Failed to connect to ';
const String msgTimeoutConnecting = 'Timeout connecting to ';
const String msgAllConnectivityTestsFailed = 'All connectivity tests failed';
const String msgInternetConnectionError = 'Internet connection error:';
const String msgTimeoutError = 'Timeout error:';
const String msgGeneralInternetConnectionError = 'General internet connection error:';

// widgets/message_input.dart debug and user text messages
const String msgSelectedImageNotFound = 'Seçilen görsel bulunamadı.';
const String msgErrorPickingImage = 'Görsel seçilirken bir hata oluştu.';
const String msgTakenPhotoNotSaved = 'Çekilen fotoğraf kaydedilemedi.';
const String msgErrorTakingPhoto = 'Fotoğraf çekilirken bir hata oluştu.';
const String msgImageLoadError = 'Görsel yükleme hatası:';
const String msgImageNotLoaded = 'Görsel yüklenemedi';
const String tooltipAddImage = 'Görsel Ekle';
const String tooltipTakePhoto = 'Fotoğraf Çek';
const String hintTextMessage = 'Mesaj yazın...';

// widgets/message_bubble.dart debug and user text messages
const String textCopyToClipboard = 'Metni kopyalamak için menüyü açın';
const String textMessageCopied = 'Mesaj panoya kopyalandı';
const String textMessageCopyError = 'Mesaj kopyalanırken hata oluştu';
const String textMessageEmpty = 'Kopyalanacak mesaj içeriği boş';
const String textRawTextCopied = 'Ham metin panoya kopyalandı';
const String textRawTextCopyError = 'Ham metin kopyalanırken hata oluştu';
const String textRawTextEmpty = 'Kopyalanacak ham metin boş';
const String textImageLoadError = 'Görsel yüklenemedi';
const String textImageFormatError = 'Görsel formatı desteklenmiyor';
const String textDeleteMessageTitle = 'Mesajı Sil';
const String textDeleteMessageConfirm = 'Bu mesajı silmek istediğinizden emin misiniz?';
const String textCancel = 'İptal';
const String textDelete = 'Sil';
const String textShowProcessed = 'İşlenmiş içeriği göster';
const String textShowRaw = 'Ham içeriği göster';
const String textMoreOptions = 'Daha fazla seçenek';
const String textCopyMessage = 'Mesajı kopyala';
const String textCopyRawText = 'Ham metni kopyala';
const String textDeleteMessage = 'Mesajı sil';

// widgets/markdown_latex_extension.dart debug and user text messages
const String latexErrorDebug = 'LaTeX Error:';
const String errorRenderingLatex = 'Error rendering LaTeX:';
const String inlineLatexErrorDebug = 'Inline LaTeX Error:';
const String latexErrorWidget = 'LaTeX Error:';

// widgets/bot_selection.dart debug and user text messages
const String labelSelectBot = 'Select a Bot';
const String labelAddNewBot = 'Add New Bot';
const String tooltipEditBot = 'Edit Bot';
const String labelTemp = 'Temp: ';
const String labelMax = 'Max: ';

// widgets/bot_editor_dialog.dart debug and user text messages
const String titleCreateBot = 'Create New Bot';
const String titleEditBot = 'Edit Bot';
const String labelBotName = 'Bot Name';
const String hintBotName = 'Enter a name for your bot';
const String errorBotName = 'Please enter a bot name';
const String labelModel = 'Model';
const String labelSystemPrompt = 'System Prompt';
const String hintSystemPrompt = 'Enter instructions for the bot';
const String errorSystemPrompt = 'Please enter a system prompt';
const String labelTemperature = 'Temperature: ';
const String labelTemperatureHelp = 'Lower values = more precise, higher values = more creative';
const String labelMaxTokens = 'Max Tokens: ';
const String labelIcon = 'Icon:';
const String buttonCancel = 'Cancel';
const String buttonCreate = 'Create';
const String buttonUpdate = 'Update';

// screens/welcome_screen.dart debug and user text messages
const String appTitle = 'OpenRouter Sohbet Uygulaması';
const String appSubtitle = 'Başlamak için OpenRouter API anahtarını girin';
const String labelApiKey = 'OpenRouter API Anahtarı';
const String hintApiKey = 'sk-...';
const String apiKeyInfo = 'API anahtarınız cihazınızda güvenli bir şekilde saklanacak ve sadece OpenRouter servisleriyle iletişim için kullanılacaktır.';
const String buttonContinue = 'Devam Et';
const String buttonSkip = 'Şimdilik Atla (Test için)';
const String errorEnterApiKey = 'Lütfen geçerli bir API anahtarı girin';
const String errorInvalidApiKey = 'Geçersiz API anahtarı formatı. OpenRouter anahtarları "sk-" ile başlamalıdır.';
const String successApiKeySaved = 'API anahtarı başarıyla kaydedildi';

// screens/settings_screen.dart debug and user text messages
const String textSettings = 'Ayarlar';
const String textApiKey = 'API Anahtarı';
const String textApiKeyHint = 'OpenRouter API anahtarınızı girin';
const String textApiKeyError = 'API anahtarı boş olamaz';
const String textShowRawFormat = 'Ham Formatı Göster';
const String textShowRawFormatDesc = 'Mesajları ham formatında göster';
const String textTemperature = 'Sıcaklık';
const String textTemperatureDesc = 'Yanıtların yaratıcılık seviyesi (0.0 - 2.0)';
const String textMaxTokens = 'Maksimum Token';
const String textMaxTokensDesc = 'Yanıtlar için maksimum token sayısı';
const String textSystemPrompt = 'Sistem Promptu';
const String textSystemPromptDesc = 'AI asistanı için sistem promptu';
const String textSave = 'Kaydet';
const String textCancel = 'İptal';
const String textReset = 'Sıfırla';
const String textResetConfirm = 'Tüm ayarlar varsayılan değerlerine sıfırlanacak. Devam etmek istiyor musunuz?';
const String textYes = 'Evet';
const String textNo = 'Hayır';
const String errorTemperatureEmpty = 'Sıcaklık değeri boş olamaz';
const String errorTemperatureRange = 'Sıcaklık değeri 0.0 ile 2.0 arasında olmalıdır';
const String errorMaxTokensEmpty = 'Maksimum token değeri boş olamaz';
const String errorMaxTokensPositive = 'Maksimum token değeri pozitif bir sayı olmalıdır';

// screens/session_list_screen.dart debug and user text messages
const String titleDeleteSessions = 'Sohbetleri Sil';
const String confirmDeleteSessions = 'sohbeti silmek istediğinizden emin misiniz?';
const String labelCancel = 'İptal';
const String labelDelete = 'Sil';
const String labelSelectedSessions = 'sohbet seçildi';
const String titleSessionList = 'Sohbet Listesi';
const String tooltipSelectAll = 'Tümünü Seç';
const String tooltipDeleteSelected = 'Seçilenleri Sil';
const String tooltipDeleteSessions = 'Sohbetleri Sil';
const String tooltipNewSession = 'Yeni Sohbet';
const String labelNoSessions = 'Henüz hiç sohbet yok. Yeni bir sohbet oluşturun.';
const String labelNewSession = 'Yeni Sohbet';
const String titleDeleteSession = 'Sohbeti Sil';
const String confirmDeleteSession = 'Bu sohbeti silmek istediğinizden emin misiniz?';
const String labelActive = 'Aktif';
const String labelYesterday = 'Dün';

// screens/network_error_screen.dart debug and user text messages
const String textConnectionError = 'Bağlantı Hatası';
const String textNoInternet = 'İnternet bağlantısı bulunamadı';
const String textCheckConnection = 'Uygulamanın çalışması için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.';
const String textChecking = 'Kontrol ediliyor...';
const String textRetry = 'Tekrar Dene';
const String textDiagnostics = 'Tanı Bilgileri:';

// screens/chat_screen.dart debug and user text messages
const String textNoInternet = 'İnternet bağlantısı yok. Mesaj göndermek için bağlantı gereklidir.';
const String textApiServiceUnavailable = 'API servisine erişilemiyor. Lütfen internet bağlantınızı ve API anahtarınızı kontrol edin.';
const String textApiServiceError = 'API servisi kontrolü sırasında hata:';
const String textSessionList = 'Sohbet Listesi';
const String textClearChat = 'Sohbeti Temizle';
const String textClearChatConfirm = 'Tüm mesajlaşma geçmişini silmek istediğinizden emin misiniz?';
const String textCancel = 'İptal';
const String textClear = 'Temizle';
const String textSettings = 'Settings';
const String textApiKeyRequired = 'API Anahtarı Gerekli';
const String textApiKeyRequiredDesc = 'Lütfen ayarlardan OpenRouter API anahtarınızı tanımlayın';
const String textSettingsButton = 'Ayarlar';
const String textBotNotSelected = 'Bot Seçilmedi';
const String textSelectBotToStart = 'Sohbete başlamak için bir bot seçin';
const String textSelectBot = 'Bot Seç';
const String textNoMessages = 'Henüz mesaj yok';
const String textSendMessageToStart = 'Konuşmaya başlamak için aşağıdan mesaj gönderin';
const String textYourBots = 'Your Bots';
const String textAddNewBot = 'Add New Bot';
const String textNoBotsConfigured = 'No bots configured yet';
const String textAddBotToStart = 'Add a new bot to start chatting';
const String textDeleteBot = 'Delete Bot';
const String textDeleteBotConfirm = 'Are you sure you want to delete';
const String textDelete = 'Delete';
const String textLoadingModels = 'Loading available models...';
const String textErrorLoadingModels = 'Error loading models:';
const String textBotEditCancel = 'Cancel';

// screens/chat_screen.dart kalan user text messages
const String textOpenRouterChat = 'OpenRouter Chat';
const String textRetry = 'Tekrar Dene';
const String textSetApiKeyForBots = 'Please set an API key in settings before creating or editing bots.';

// providers/settings_provider.dart debug and user text messages
const String msgErrorLoadingSettings = 'Error loading settings:';
const String msgErrorSavingSettings = 'Error saving settings:';
const String themeModeDark = 'dark';
const String themeModeLight = 'light';

// providers/chat_provider.dart debug and user text messages
const String msgErrorLoadingSessions = 'Error loading sessions:';
const String msgErrorSavingSessions = 'Error saving sessions:';
const String msgPleaseSelectBot = 'Please select a bot first';
const String msgImageUploadFailed = 'Görsel yükleme başarısız oldu';
const String msgErrorSendingMessage = 'Error sending message:';
const String msgErrorWhileSending = 'Mesaj gönderilirken bir hata oluştu';
const String msgThinking = 'Düşünüyor...';
const String msgFailedToGenerateResponse = 'Failed to generate response';
const String msgErrorGeneratingResponse = 'Error generating response:';

// providers/bot_provider.dart user-visible string constants
const String msgErrorInitializingBots = 'Error initializing bots:';
const String msgErrorSavingBots = 'Error saving bots:';
const String msgBotNotFound = 'Bot not found';
const String msgBotName = 'Bots';

// main.dart user-visible string constants
const String msgCheckingConnection = 'Bağlantı kontrol ediliyor...';
const String msgConnectionErrorDebug = 'Bağlantı kontrol hatası: ';
const String appTitle = 'OpenRouter Chat';
