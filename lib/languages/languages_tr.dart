// Default location: lib/languages/languages_tr.dart
// Uygulamanın tamamı için kullanıcıya gösterilecek metin sabitleri (Türkçe)
// Kullanım: Languages.textCancel, Languages.textDelete, vb.

class Languages {
  // services/openrouter_service.dart hata ve kullanıcı mesajları
  static const String errorApiKeyNotInitialized = 'Hata: API anahtarı başlatılmadı';
  static const String warningEmptyApiKey = 'Uyarı: Boş bir API anahtarı ile OpenRouterService başlatılmaya çalışıldı';
  static const String errorApiKeyNotInitializedForTest = 'Hata: Test için API anahtarı başlatılmadı';
  static const String errorApiKeyNotInitializedFetchingModels = 'Hata: API anahtarı başlatılmadı, varsayılan modeller dönüyor';
  static const String errorNoInternetFetchingModels = 'Hata: Modeller alınırken internet bağlantısı yok';
  static const String warningNoModelsFound = 'Uyarı: Model bulunamadı, varsayılanlar dönüyor';
  static const String errorFetchingModels = 'Modeller alınırken hata:';
  static const String dioExceptionFetchingModels = 'Modeller alınırken DioException:';
  static const String timeoutFetchingModels = 'Modeller alınırken zaman aşımı:';
  static const String errorGeneratingChatResponse = 'Sohbet yanıtı oluşturulurken hata:';
  static const String apiErrorPrefix = 'API Hatası:';
  static const String errorRateLimitReached = 'Üzgünüz, günlük kullanım sınırına ulaştınız. Lütfen daha sonra tekrar deneyin.';
  static const String errorMessageFormatting = 'Mesaj biçimlendirme hatası:';
  static const String errorGeneratingTitle = 'Başlık oluşturulurken hata:';
  static const String errorNoInternetGeneratingTitle = 'Hata: Başlık oluşturulurken internet bağlantısı yok';
  static const String connectionErrorTitle = 'Bağlantı Hatası';
  static const String errorApiTestFailedDio = 'API testi başarısız (DioException):';
  static const String errorApiTestFailedTimeout = 'API testi başarısız (Zaman aşımı):';
  static const String errorApiTestFailed = 'API testi başarısız:';
  static const String errorNoInternetImageUpload = 'Hata: Görsel yükleme için internet bağlantısı yok';
  static const String exceptionNoInternetImageUpload = 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.';
  static const String errorImageFileNotExist = 'Hata: Görsel dosyası mevcut değil:';
  static const String exceptionImageFileNotFound = 'Görsel dosyası bulunamadı:';
  static const String errorImageSizeTooLarge = 'Hata: Görsel boyutu 25MB sınırını aşıyor';
  static const String exceptionImageSizeTooLarge = 'Görsel boyutu çok büyük (maksimum 25MB).';
  static const String errorInUploadImage = 'Görsel yüklemede hata:';
  static const String unexpectedErrorUploadingImage = 'Görsel yüklenirken beklenmeyen hata:';
  static const String defaultModelsMessage = 'İnternet bağlantınızı veya API anahtarınızı kontrol edin';

  // services/network_service.dart hata ve kullanıcı mesajları
  static const String msgNoConnectivity = 'Bağlantı yok:';
  static const String msgLookupTimeout = ' arama zaman aşımı';
  static const String msgSuccessfullyConnected = 'Başarıyla bağlanıldı: ';
  static const String msgFailedToConnect = 'Bağlanılamadı: ';
  static const String msgTimeoutConnecting = 'Bağlanırken zaman aşımı: ';
  static const String msgAllConnectivityTestsFailed = 'Tüm bağlantı testleri başarısız';
  static const String msgInternetConnectionError = 'İnternet bağlantı hatası:';
  static const String msgTimeoutError = 'Zaman aşımı hatası:';
  static const String msgGeneralInternetConnectionError = 'Genel internet bağlantı hatası:';

  // widgets/message_input.dart hata ve kullanıcı mesajları
  static const String msgSelectedImageNotFound = 'Seçilen görsel bulunamadı.';
  static const String msgErrorPickingImage = 'Görsel seçilirken bir hata oluştu.';
  static const String msgTakenPhotoNotSaved = 'Çekilen fotoğraf kaydedilemedi.';
  static const String msgErrorTakingPhoto = 'Fotoğraf çekilirken bir hata oluştu.';
  static const String msgImageLoadError = 'Görsel yükleme hatası:';
  static const String msgImageNotLoaded = 'Görsel yüklenemedi';
  static const String tooltipAddImage = 'Görsel Ekle';
  static const String tooltipTakePhoto = 'Fotoğraf Çek';
  static const String hintTextMessage = 'Mesaj yaz...';

  // widgets/message_bubble.dart hata ve kullanıcı mesajları
  static const String textCopyToClipboard = 'Metni kopyalamak için menüyü açın';
  static const String textMessageCopied = 'Mesaj panoya kopyalandı';
  static const String textMessageCopyError = 'Mesaj kopyalanırken hata';
  static const String textMessageEmpty = 'Mesaj içeriği boş';
  static const String textRawTextCopied = 'Ham metin panoya kopyalandı';
  static const String textRawTextCopyError = 'Ham metin kopyalanırken hata';
  static const String textRawTextEmpty = 'Kopyalanacak ham metin boş';
  static const String textImageLoadError = 'Görsel yüklenemedi';
  static const String textImageFormatError = 'Görsel formatı desteklenmiyor';
  static const String textDeleteMessageTitle = 'Mesajı Sil';
  static const String textDeleteMessageConfirm = 'Bu mesajı silmek istediğinizden emin misiniz?';
  static const String textCancel = 'İptal';
  static const String textDelete = 'Sil';
  static const String textShowProcessed = 'İşlenmiş içeriği göster';
  static const String textShowRaw = 'Ham içeriği göster';
  static const String textMoreOptions = 'Daha fazla seçenek';
  static const String textCopyMessage = 'Mesajı kopyala';
  static const String textCopyRawText = 'Ham metni kopyala';
  static const String textDeleteMessage = 'Mesajı sil';

  // widgets/markdown_latex_extension.dart hata ve kullanıcı mesajları
  static const String latexErrorDebug = 'LaTeX Hatası:';
  static const String errorRenderingLatex = 'LaTeX render edilirken hata:';
  static const String inlineLatexErrorDebug = 'Satır içi LaTeX Hatası:';
  static const String latexErrorWidget = 'LaTeX Hatası:';

  // widgets/bot_selection.dart hata ve kullanıcı mesajları
  static const String labelSelectBot = 'Bot Seç';
  static const String labelAddNewBot = 'Yeni Bot Ekle';
  static const String tooltipEditBot = 'Botu Düzenle';
  static const String labelTemp = 'Sıcaklık: ';
  static const String labelMax = 'Maks: ';

  // widgets/bot_editor_dialog.dart hata ve kullanıcı mesajları
  static const String titleCreateBot = 'Yeni Bot Oluştur';
  static const String titleEditBot = 'Botu Düzenle';
  static const String labelBotName = 'Bot Adı';
  static const String hintBotName = 'Botunuz için bir ad girin';
  static const String errorBotName = 'Lütfen bir bot adı girin';
  static const String labelModel = 'Model';
  static const String labelSystemPrompt = 'Sistem Komutu';
  static const String hintSystemPrompt = 'Bot için talimatları girin';
  static const String errorSystemPrompt = 'Lütfen bir sistem komutu girin';
  static const String labelTemperature = 'Sıcaklık: ';
  static const String labelTemperatureHelp = 'Düşük değerler = daha kesin, yüksek değerler = daha yaratıcı';
  static const String labelMaxTokens = 'Maksimum Token: ';
  static const String labelIcon = 'İkon:';
  static const String buttonCancel = 'İptal';
  static const String buttonCreate = 'Oluştur';
  static const String buttonUpdate = 'Güncelle';

  // screens/welcome_screen.dart hata ve kullanıcı mesajları
  static const String appTitle = 'OpenRouter Sohbet Uygulaması';
  static const String appSubtitle = 'Başlamak için OpenRouter API anahtarınızı girin';
  static const String labelApiKey = 'OpenRouter API Anahtarı';
  static const String hintApiKey = 'sk-...';
  static const String apiKeyInfo = 'API anahtarınız cihazınızda güvenli bir şekilde saklanacak ve yalnızca OpenRouter servisleriyle iletişimde kullanılacaktır.';
  static const String buttonContinue = 'Devam Et';
  static const String buttonSkip = 'Şimdilik atla (test için)';
  static const String errorEnterApiKey = 'Lütfen geçerli bir API anahtarı girin';
  static const String errorInvalidApiKey = 'Geçersiz API anahtarı formatı. OpenRouter anahtarları "sk-" ile başlamalıdır.';
  static const String successApiKeySaved = 'API anahtarı başarıyla kaydedildi';

  // screens/settings_screen.dart hata ve kullanıcı mesajları
  static const String textSettings = 'Ayarlar';
  static const String textApiKey = 'API Anahtarı';
  static const String textApiKeyHint = 'OpenRouter API anahtarınızı girin';
  static const String textApiKeyError = 'API anahtarı boş olamaz';
  static const String textShowRawFormat = 'Ham Formatı Göster (latex için)';
  static const String textShowRawFormatDesc = 'Mesajları ham formatta göster (latex için)';
  static const String textTemperature = 'Sıcaklık';
  static const String textTemperatureDesc = 'Yanıtların yaratıcılık seviyesi (0.0 - 2.0)';
  static const String textMaxTokens = 'Maksimum Token';
  static const String textMaxTokensDesc = 'Yanıtlar için maksimum token sayısı';
  static const String textSystemPrompt = 'Sistem Komutu';
  static const String textSystemPromptDesc = 'AI asistanı için sistem komutu';
  static const String textSave = 'Kaydet';
  static const String textReset = 'Sıfırla';
  static const String textResetConfirm = 'Tüm ayarlar varsayılan değerlere sıfırlanacak. Devam etmek istiyor musunuz?';
  static const String textYes = 'Evet';
  static const String textNo = 'Hayır';
  static const String errorTemperatureEmpty = 'Sıcaklık değeri boş olamaz';
  static const String errorTemperatureRange = 'Sıcaklık değeri 0.0 ile 2.0 arasında olmalı';
  static const String errorMaxTokensEmpty = 'Maksimum token değeri boş olamaz';
  static const String errorMaxTokensPositive = 'Maksimum token değeri pozitif bir sayı olmalı';

  // screens/session_list_screen.dart hata ve kullanıcı mesajları
  static const String titleDeleteSessions = 'Oturumları Sil';
  static const String confirmDeleteSessions = 'Seçili oturumları silmek istediğinizden emin misiniz?';
  static const String labelCancel = 'İptal';
  static const String labelDelete = 'Sil';
  static const String labelSelectedSessions = 'oturum seçildi';
  static const String titleSessionList = 'Oturum Listesi';
  static const String tooltipSelectAll = 'Tümünü Seç';
  static const String tooltipDeleteSelected = 'Seçiliyi Sil';
  static const String tooltipDeleteSessions = 'Oturumları Sil';
  static const String tooltipNewSession = 'Yeni Oturum';
  static const String labelNoSessions = 'Henüz oturum yok. Yeni bir oturum oluşturun.';
  static const String labelNewSession = 'Yeni Oturum';
  static const String titleDeleteSession = 'Oturumu Sil';
  static const String confirmDeleteSession = 'Bu oturumu silmek istediğinizden emin misiniz?';
  static const String labelActive = 'Aktif';
  static const String labelYesterday = 'Dün';

  // screens/network_error_screen.dart hata ve kullanıcı mesajları
  static const String textConnectionError = 'Bağlantı Hatası';
  static const String textNoInternet = 'İnternet bağlantısı bulunamadı';
  static const String textCheckConnection = 'Uygulamanın çalışması için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.';
  static const String textChecking = 'Kontrol ediliyor...';
  static const String textRetry = 'Yeniden Dene';
  static const String textDiagnostics = 'Tanı:';

  // screens/chat_screen.dart hata ve kullanıcı mesajları
  static const String textApiServiceUnavailable = 'API servisi kullanılamıyor. Lütfen internet bağlantınızı ve API anahtarınızı kontrol edin.';
  static const String textApiServiceError = 'API servisi kontrol edilirken hata:';
  static const String textSessionList = 'Oturum Listesi';
  static const String textClearChat = 'Sohbeti Temizle';
  static const String textClearChatConfirm = 'Tüm sohbet geçmişini temizlemek istediğinizden emin misiniz?';
  static const String textClear = 'Temizle';
  static const String textApiKeyRequired = 'API Anahtarı Gerekli';
  static const String textApiKeyRequiredDesc = 'Lütfen ayarlardan OpenRouter API anahtarınızı tanımlayın';
  static const String textSettingsButton = 'Ayarlar';
  static const String textBotNotSelected = 'Bot Seçilmedi';
  static const String textSelectBotToStart = 'Sohbete başlamak için bir bot seçin';
  static const String textSelectBot = 'Bot Seç';
  static const String textNoMessages = 'Henüz mesaj yok';
  static const String textSendMessageToStart = 'Sohbete başlamak için aşağıya bir mesaj gönderin';
  static const String textYourBots = 'Botlarınız';
  static const String textAddNewBot = 'Yeni Bot Ekle';
  static const String textNoBotsConfigured = 'Henüz bot yapılandırılmadı';
  static const String textAddBotToStart = 'Sohbete başlamak için yeni bir bot ekleyin';
  static const String textDeleteBot = 'Botu Sil';
  static const String textDeleteBotConfirm = 'Silmek istediğinizden emin misiniz';
  static const String textLoadingModels = 'Mevcut modeller yükleniyor...';
  static const String textErrorLoadingModels = 'Modeller yüklenirken hata:';
  static const String textBotEditCancel = 'İptal';
  static const String textOpenRouterChat = 'OpenRouter Sohbet';
  static const String textSetApiKeyForBots = 'Bot oluşturmak veya düzenlemek için lütfen ayarlardan bir API anahtarı tanımlayın.';

  // providers/settings_provider.dart hata ve kullanıcı mesajları
  static const String msgErrorLoadingSettings = 'Ayarlar yüklenirken hata:';
  static const String msgErrorSavingSettings = 'Ayarlar kaydedilirken hata:';
  static const String themeModeDark = 'koyu';
  static const String themeModeLight = 'açık';

  // providers/chat_provider.dart hata ve kullanıcı mesajları
  static const String msgErrorLoadingSessions = 'Oturumlar yüklenirken hata:';
  static const String msgErrorSavingSessions = 'Oturumlar kaydedilirken hata:';
  static const String msgPleaseSelectBot = 'Lütfen önce bir bot seçin';
  static const String msgImageUploadFailed = 'Görsel yükleme başarısız';
  static const String msgErrorSendingMessage = 'Mesaj gönderilirken hata:';
  static const String msgErrorWhileSending = 'Mesaj gönderilirken bir hata oluştu';
  static const String msgThinking = 'Düşünüyor...';
  static const String msgFailedToGenerateResponse = 'Yanıt oluşturulamadı';
  static const String msgErrorGeneratingResponse = 'Yanıt oluşturulurken hata:';

  // providers/bot_provider.dart kullanıcıya gösterilecek metin sabitleri
  static const String msgErrorInitializingBots = 'Botlar başlatılırken hata:';
  static const String msgErrorSavingBots = 'Botlar kaydedilirken hata:';
  static const String msgBotNotFound = 'Bot bulunamadı';
  static const String msgBotName = 'Botlar';

  // main.dart kullanıcıya gösterilecek metin sabitleri
  static const String msgCheckingConnection = 'Bağlantı kontrol ediliyor...';
  static const String msgConnectionErrorDebug = 'Bağlantı kontrolü hatası: ';
  static const String appTitleMain = 'OpenRouter Sohbet';

  // openrouter_service.dart
  static const String errorNoInternetRetryCancelled = 'İnternet bağlantısı yok, yeniden deneme iptal edildi.';
  static const String errorMaxRetriesReached = 'Maksimum deneme sayısına ulaşıldı. Vazgeçiliyor.';
  static const String usingSelectedModel = 'Seçilen model kullanılıyor:';
  static const String sendingApiRequest = 'Model ile API isteği gönderiliyor:';
  static const String requestPayload = 'İstek yükü:';
  static const String chatTitle = 'Sohbet';
  static const String generateShortDescriptiveTitle = 'Aşağıdaki içerik için kısa ve açıklayıcı bir başlık oluştur.';
  static const String titleShouldBeMaximum5Words = 'Başlık en fazla 5 kelime olmalı';
  static const String sayOkIfYouCanReadThis = 'Bunu okuyabiliyorsan "OK" de';
  static const String imageConvertedToBase64WithMimeType = 'Görsel MIME türü ile base64 olarak dönüştürüldü:';

}
