// Default location: lib/languages/languages_tr.dart
// Uygulamanın tamamı için kullanıcıya gösterilecek metin sabitleri (Türkçe)

class Languages {
  static const String appTitleMain = 'FlutterAI';
  static const String appSubtitle = 'Yapay Zeka Sohbet Asistanınız';

  // services/openrouter_service.dart hata ve kullanıcı mesajları
  static const String errorApiKeyNotInitialized = 'Hata: API anahtarı başlatılmadı';
  static const String warningEmptyApiKey = 'Uyarı: Boş bir API anahtarı ile OpenRouterService başlatılmaya çalışıldı';
  static const String errorApiKeyNotInitializedForTest = 'Hata: Test için API anahtarı başlatılmadı';
  static const String errorApiKeyNotInitializedFetchingModels = 'Hata: API anahtarı başlatılmadı, varsayılan modeller dönüyor';
  static const String errorNoInternetFetchingModels = 'Hata: Modeller alınırken internet bağlantısı yok';
  static const String errorNetworkConnection = 'Hata: Ağ bağlantısı başarısız';

  // providers/settings_provider.dart
  static const String msgErrorLoadingSettings = 'Ayarlar yüklenirken hata oluştu';
  static const String msgErrorSavingSettings = 'Ayarlar kaydedilirken hata oluştu';

  // providers/bot_provider.dart
  static const String msgErrorLoadingBots = 'Botlar yüklenirken hata oluştu';
  static const String msgErrorSavingBots = 'Botlar kaydedilirken hata oluştu';

  // providers/chat_provider.dart
  static const String msgPleaseSelectBot = 'Lütfen bir bot seçin';

  // welcome_screen.dart & settings_screen.dart
  static const String labelApiKey = 'API Anahtarı';
  static const String hintApiKey = 'OpenRouter veya OpenAI API anahtarınızı girin';
  static const String apiKeyInfo = 'API anahtarınız cihazınızda güvenle saklanır.';
  static const String buttonContinue = 'Devam Et';
  static const String buttonSkip = 'Atla';
  static const String errorEnterApiKey = 'Lütfen bir API anahtarı girin';
  static const String errorInvalidApiKey = 'Geçersiz API anahtarı biçimi';
  static const String successApiKeySaved = 'API anahtarı başarıyla kaydedildi';

  // widgets/bot_selection.dart
  static const String labelSelectBot = 'Bot Seç';

  // widgets/message_input.dart
  static const String msgSelectedImageNotFound = 'Seçilen görsel dosyası bulunamadı';
  static const String msgImageLoadError = 'Görsel yüklenirken hata oluştu';
  static const String msgErrorPickingImage = 'Görsel seçilirken hata oluştu';
  static const String msgTakenPhotoNotSaved = 'Çekilen fotoğraf kaydedilemedi';
  static const String msgErrorTakingPhoto = 'Fotoğraf çekilirken hata oluştu';
  static const String msgImageNotLoaded = 'Görsel yüklenemedi';
  static const String tooltipAddImage = 'Görsel Ekle';
  static const String hintTextMessage = 'Bir mesaj yazın...';

  // screens/chat_screen.dart
  static const String textSelectBotToStart = 'Sohbete başlamak için bir bot seçin';
  static const String textSelectBot = 'Bot Seç';
  static const String textNoMessages = 'Henüz mesaj yok';
  static const String textSendMessageToStart = 'Sohbete başlamak için aşağıya bir mesaj gönderin';
  static const String textYourBots = 'Botlarınız';
  static const String textAddNewBot = 'Yeni Bot Ekle';
  static const String textNoBotsConfigured = 'Henüz bot yapılandırılmadı';
  static const String errorRenderingLatex = 'LaTeX işlenirken hata oluştu';
}
