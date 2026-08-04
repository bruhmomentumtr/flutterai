// Default location: lib/languages/languages_tr.dart
// Uygulamanın tamamı için kullanıcıya gösterilecek metin sabitleri (Türkçe)

class Languages {
  static const String appTitleMain = 'FlutterAI';
  static const String appSubtitle = 'Yapay Zeka Sohbet Asistanınız';

  // services/openrouter_service.dart hata ve kullanıcı mesajları
  static const String errorApiKeyNotInitialized =
      'Hata: API anahtarı başlatılmadı';
  static const String warningEmptyApiKey =
      'Uyarı: Boş bir API anahtarı ile OpenRouterService başlatılmaya çalışıldı';
  static const String errorApiKeyNotInitializedForTest =
      'Hata: Test için API anahtarı başlatılmadı';
  static const String errorApiKeyNotInitializedFetchingModels =
      'Hata: API anahtarı başlatılmadı, varsayılan modeller dönüyor';
  static const String errorNoInternetFetchingModels =
      'Hata: Modeller alınırken internet bağlantısı yok';
  static const String errorNetworkConnection = 'Hata: Ağ bağlantısı başarısız';

  // providers/settings_provider.dart
  static const String msgErrorLoadingSettings =
      'Ayarlar yüklenirken hata oluştu';
  static const String msgErrorSavingSettings =
      'Ayarlar kaydedilirken hata oluştu';

  // providers/bot_provider.dart
  static const String msgErrorLoadingBots = 'Botlar yüklenirken hata oluştu';
  static const String msgErrorSavingBots = 'Botlar kaydedilirken hata oluştu';

  // providers/chat_provider.dart
  static const String msgPleaseSelectBot = 'Lütfen bir bot seçin';

  // welcome_screen.dart & settings_screen.dart
  static const String labelApiKey = 'API Anahtarı';
  static const String hintApiKey =
      'OpenRouter veya OpenAI API anahtarınızı girin';
  static const String apiKeyInfo =
      'API anahtarınız cihazınızda güvenle saklanır.';
  static const String buttonContinue = 'Devam Et';
  static const String buttonSkip = 'Atla';
  static const String errorEnterApiKey = 'Lütfen bir API anahtarı girin';
  static const String errorInvalidApiKey = 'Geçersiz API anahtarı biçimi';
  static const String successApiKeySaved = 'API anahtarı başarıyla kaydedildi';

  // bot_editor_dialog.dart
  static const String titleCreateBot = 'Bot Oluştur';
  static const String titleEditBot = 'Botu Düzenle';
  static const String labelBotName = 'Bot Adı';
  static const String hintBotName = 'Bot adını girin';
  static const String errorBotName = 'Lütfen bir bot adı girin';
  static const String labelModel = 'Model';
  static const String labelSystemPrompt = 'Sistem Yönergesi (System Prompt)';
  static const String hintSystemPrompt = 'Sistem yönergesini girin';
  static const String errorSystemPrompt = 'Lütfen sistem yönergesi girin';
  static const String labelTemperature = 'Sıcaklık (Temperature): ';
  static const String labelTemperatureHelp =
      'Daha yüksek değerler yaratıcı yanıtlar üretir.';
  static const String labelMaxTokens = 'Maksimum Jeton (Max Tokens): ';
  static const String labelIcon = 'Simge';
  static const String buttonCancel = 'İptal';
  static const String buttonCreate = 'Oluştur';
  static const String buttonUpdate = 'Güncelle';

  // widgets/bot_selection.dart
  static const String labelSelectBot = 'Bot Seç';

  // widgets/message_input.dart
  static const String msgSelectedImageNotFound =
      'Seçilen görsel dosyası bulunamadı';
  static const String msgImageLoadError = 'Görsel yüklenirken hata oluştu';
  static const String msgErrorPickingImage = 'Görsel seçilirken hata oluştu';
  static const String msgTakenPhotoNotSaved = 'Çekilen fotoğraf kaydedilemedi';
  static const String msgErrorTakingPhoto = 'Fotoğraf çekilirken hata oluştu';
  static const String msgImageNotLoaded = 'Görsel yüklenemedi';
  static const String tooltipAddImage = 'Görsel Ekle';
  static const String hintTextMessage = 'Bir mesaj yazın...';
  static const String labelImageReady = 'Görsel gönderilmeye hazır';
  static const String errorConvertImage = 'Seçilen görsel işlenemedi';

  // widgets/markdown_latex_extension.dart
  static const String latexErrorWidget = 'LaTeX görüntülenemiyor';
  static const String latexErrorDebug = 'LaTeX işleme hatası';
  static const String inlineLatexErrorDebug = 'Satır içi LaTeX işleme hatası';

  // screens/chat_screen.dart
  static const String textSelectBotToStart =
      'Sohbete başlamak için bir bot seçin';
  static const String textSelectBot = 'Bot Seç';
  static const String textNoMessages = 'Henüz mesaj yok';
  static const String textSendMessageToStart =
      'Sohbete başlamak için aşağıya bir mesaj gönderin';
  static const String textYourBots = 'Botlarınız';
  static const String textAddNewBot = 'Yeni Bot Ekle';
  static const String textNoBotsConfigured = 'Henüz bot yapılandırılmadı';
  static const String errorRenderingLatex = 'LaTeX işlenirken hata oluştu';

  // screens/settings_screen.dart
  static const String textSettings = 'Ayarlar';
  static const String textSave = 'Kaydet';
  static const String textReset = 'Sıfırla';
  static const String textResetConfirm =
      'Tüm ayarlar varsayılana sıfırlansın mı?';
  static const String textYes = 'Evet';
  static const String textNo = 'Hayır';
  static const String textApiKey = 'API Anahtarı';
  static const String textApiKeyHint =
      'OpenRouter veya OpenAI API anahtarınızı girin';
  static const String textApiKeyError = 'API anahtarı boş olamaz';
  static const String textTemperature = 'Sıcaklık';
  static const String textTemperatureDesc =
      'Daha yüksek değerler daha yaratıcı yanıtlar üretir.';
  static const String textMaxTokens = 'Maks. Jeton';
  static const String textMaxTokensDesc =
      'Modelin yanıtı için üst jeton sınırı.';
  static const String textSystemPrompt = 'Sistem Yönergesi';
  static const String textSystemPromptDesc =
      'Sohbetten önce modele gönderilen yönerge.';
  static const String errorMaxTokensEmpty = 'Lütfen maks. jeton değerini girin';
  static const String errorMaxTokensPositive =
      'Maks. jeton pozitif bir sayı olmalı';
  static const String textShowRawFormat = 'Ham biçimi göster';
  static const String textShowRawFormatDesc =
      'Markdown ve LaTeX işlemeyi devre dışı bırakır.';

  // Reasoning effort (o1/o3, GPT-5, vb.)
  static const String textReasoningEffort = 'Akıl Yürütme Çabası';
  static const String textReasoningEffortDesc =
      'Modelin yanıt vermeden önce ne kadar düşüneceğini belirler. Destekleyen modellerde geçerlidir (örn. o1, o3, GPT-5).';
  static const String textReasoningNone = 'Yok';
  static const String textReasoningLow = 'Düşük';
  static const String textReasoningMedium = 'Orta';
  static const String textReasoningHigh = 'Yüksek';

  // screens/network_error_screen.dart
  static const String textConnectionError = 'Bağlantı hatası';
  static const String textNoInternet = 'İnternet bağlantısı yok';
  static const String textCheckConnection =
      'Lütfen ağ bağlantınızı kontrol edip tekrar deneyin.';
  static const String textChecking = 'Kontrol ediliyor...';
  static const String textRetry = 'Tekrar Dene';

  // screens/session_list_screen.dart
  static const String titleSessionList = 'Sohbetler';
  static const String labelNoSessions = 'Henüz sohbet yok';
  static const String labelNewSession = 'Yeni sohbet';
  static const String labelSelectedSessions = 'seçili';
  static const String titleDeleteSession = 'Sohbeti sil';
  static const String titleDeleteSessions = 'Sohbetleri sil';
  static const String confirmDeleteSession =
      'Bu sohbeti silmek istediğinize emin misiniz?';
  static const String confirmDeleteSessions =
      'sohbet silinecek. Devam edilsin mi?';
  static const String tooltipSelectAll = 'Tümünü seç';
  static const String tooltipDeleteSelected = 'Seçilenleri sil';
  static const String tooltipDeleteSessions = 'Sohbetleri sil';
  static const String labelDelete = 'Sil';
  static const String labelCancel = 'İptal';
  static const String labelYesterday = 'Dün';

  // bot_editor_dialog.dart
  static const String errorSystemPromptRequired =
      'Lütfen sistem yönergesi girin';
}
