// Default location: lib/languages/languages_tr.dart
// Uygulamanın tamamı için kullanıcıya gösterilecek metin sabitleri (Türkçe)

class Languages {
  static const String appTitleMain = 'FlutterAI';

  // services/openrouter_service.dart hata ve kullanıcı mesajları
  static const String errorApiKeyNotInitialized = 'Hata: API anahtarı başlatılmadı';
  static const String warningEmptyApiKey = 'Uyarı: Boş bir API anahtarı ile OpenRouterService başlatılmaya çalışıldı';
  static const String errorApiKeyNotInitializedForTest = 'Hata: Test için API anahtarı başlatılmadı';
  static const String errorApiKeyNotInitializedFetchingModels = 'Hata: API anahtarı başlatılmadı, varsayılan modeller dönüyor';
  static const String errorNoInternetFetchingModels = 'Hata: Modeller alınırken internet bağlantısı yok';
  static const String errorNetworkConnection = 'Hata: Ağ bağlantısı başarısız';

  // providers/bot_provider.dart
  static const String msgErrorLoadingBots = 'Botlar yüklenirken hata oluştu';
  static const String msgErrorSavingBots = 'Botlar kaydedilirken hata oluştu';

  // providers/chat_provider.dart
  static const String msgPleaseSelectBot = 'Lütfen bir bot seçin';

  // widgets/bot_selection.dart
  static const String labelSelectBot = 'Bot Seç';

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
