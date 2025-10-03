// Default location: lib/screens/chat_screen.dart
// Main chat screen for the application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/bot_provider.dart';
import '../models/bot.dart';
import '../services/openrouter_service.dart';
import '../services/network_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/bot_editor_dialog.dart';
import 'settings_screen.dart';
import 'session_list_screen.dart';
import '../languages/languages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _initializeBot();

    // API servisi kontrolü
    _checkApiService();
    _checkConnection(); // <-- ekle
  }

  // Bot seçimi yoksa ilk botu seç
  void _initializeBot() {
    // İlk render'dan sonra işlem yap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final botProvider = Provider.of<BotProvider>(context, listen: false);

      // Eğer bot seçili değilse ve botlar varsa, ilk botu seç
      if (chatProvider.selectedBot == null && botProvider.bots.isNotEmpty) {
        chatProvider.selectBot(botProvider.bots.first);
      }
    });
  }

  // API servisini kontrol et
  Future<void> _checkApiService() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    try {
      final bool isAvailable = await chatProvider.isApiServiceAvailable();
      if (!isAvailable && mounted) {
        // API servisine erişilemiyorsa kullanıcıya bildir
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textApiServiceUnavailable),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Languages.textApiServiceError} $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _checkConnection() async {
    final isConnected = await NetworkService.isConnected();
    if (mounted) {
      setState(() {
        _hasConnection = isConnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            final bot = chatProvider.selectedBot;
            return Row(
              children: [
                Icon(
                  bot != null ? _getIconData(bot.iconName) : Icons.chat,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(bot?.name ?? Languages.textOpenRouterChat),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: Languages.textSessionList,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SessionListScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: Languages.textClearChat,
            onPressed: () {
              final chatProvider = context.read<ChatProvider>();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(Languages.textClearChat),
                  content: const Text(Languages.textClearChatConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(Languages.textCancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        chatProvider.clearChat();
                        Navigator.of(context).pop();
                      },
                      child: const Text(Languages.textClear),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: Languages.textSettings,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<ChatProvider, SettingsProvider>(
        builder: (context, chatProvider, settingsProvider, _) {
          // If no API key is set, show a message to set one
          if (!settingsProvider.hasApiKey) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.api,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    Languages.textApiKeyRequired,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    Languages.textApiKeyRequiredDesc,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text(Languages.textSettingsButton),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          // If no bot is selected, show a message to select one
          if (chatProvider.selectedBot == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.smart_toy,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    Languages.textBotNotSelected,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    Languages.textSelectBotToStart,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton.icon(
                    icon: const Icon(Icons.science),
                    label: const Text(Languages.textSelectBot),
                    onPressed: () {
                      // Open drawer to select a bot
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // İnternet yoksa üstte uyarı göster
                if (!_hasConnection)
                  MaterialBanner(
                    content: Text(
                      Languages.textNoInternet,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                    leading: Icon(Icons.wifi_off,
                        color: Theme.of(context).colorScheme.secondary),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    actions: [
                      TextButton(
                        onPressed: _checkConnection,
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Text(Languages.textRetry),
                      ),
                    ],
                  ),
                // Error message display
                if (chatProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            chatProvider.error!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: chatProvider.clearError,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ],
                    ),
                  ),

                // Chat messages list
                Expanded(
                  child: chatProvider.messages.isEmpty
                      ? _buildEmptyChat()
                      : _buildChatMessages(chatProvider),
                ),

                // Message input
                MessageInput(
                  onSendMessage: (content, imageFile) {
                    chatProvider.sendMessage(content, imageFile: imageFile);
                  },
                  isLoading: chatProvider.isLoading,
                ),
              ],
            ),
          );
        },
      ),
      drawer: const BotSelectionDrawer(),
    );
  }

  Widget _buildChatMessages(ChatProvider chatProvider) {
    return GestureDetector(
      onTap: () {
        // Klavyeyi kapat
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        // keys çok önemli, yeniden renderlamaları optimize eder
        key: PageStorageKey<String>(chatProvider.currentSessionId),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        reverse: true, // Son mesajdan başla (baştan değil)
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: chatProvider.messages.length,
        itemBuilder: (context, index) {
          // Mesajları sondan başa sırala (reverse: true olduğu için)
          final message =
              chatProvider.messages[chatProvider.messages.length - 1 - index];

          // Key burada kritik - aynı ID'yi kullanmak yerine index + id kombinasyonu daha güvenli
          final itemKey = ValueKey<String>(
              '${chatProvider.currentSessionId}_${message.id}_$index');

          return Padding(
            key: itemKey,
            padding: const EdgeInsets.only(bottom: 4.0),
            child: MessageBubble(message: message),
          );
        },
        // Kötü performans durumunda ListView'ın yeniden build edilmesini azalt
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(128),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Languages.textNoMessages,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        Languages.textSendMessageToStart,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat;
      case 'smart_toy':
        return Icons.smart_toy;
      case 'edit':
        return Icons.edit;
      case 'science':
        return Icons.science;
      case 'school':
        return Icons.school;
      case 'code':
        return Icons.code;
      default:
        return Icons.android;
    }
  }
}

class BotSelectionDrawer extends StatelessWidget {
  const BotSelectionDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.85, // Geniş cihazlarda drawer'ı daha geniş yap
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy),
                  const SizedBox(width: 16.0),
                  const Text(
                    Languages.textYourBots,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: Languages.textAddNewBot,
                    onPressed: () {
                      // Show dialog to add a new bot
                      _showBotEditorDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return _buildBotList(context, chatProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotList(BuildContext context, ChatProvider chatProvider) {
    // You would need to implement a BotProvider to get the list of bots
    // For now, using a placeholder implementation
    final botProvider = Provider.of<BotProvider>(context);

    if (!botProvider.hasBots) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16.0),
            Text(
              Languages.textNoBotsConfigured,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 8.0),
            Text(
              Languages.textAddBotToStart,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline, fontSize: 12.0),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: botProvider.bots.length,
      itemBuilder: (context, index) {
        final bot = botProvider.bots[index];
        final isSelected = chatProvider.selectedBot?.id == bot.id;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          elevation: isSelected ? 2 : 0,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(128),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getIconData(bot.iconName),
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ),
            title: Text(
              bot.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(128),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                bot.model,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {
                    // Show dialog to edit bot
                    _showBotEditorDialog(context, bot: bot);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(Languages.textDeleteBot),
                        content: Text(
                            '${Languages.textDeleteBotConfirm} ${bot.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(Languages.textBotEditCancel),
                          ),
                          FilledButton(
                            onPressed: () {
                              botProvider.deleteBot(bot.id);
                              Navigator.of(context).pop();
                            },
                            child: const Text(Languages.textDelete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            selected: isSelected,
            onTap: () {
              chatProvider.selectBot(bot);
              Navigator.of(context).pop(); // Close drawer after selection
            },
          ),
        );
      },
    );
  }

  // Helper method to get icon data from string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat;
      case 'smart_toy':
        return Icons.smart_toy;
      case 'edit':
        return Icons.edit;
      case 'science':
        return Icons.science;
      case 'school':
        return Icons.school;
      case 'code':
        return Icons.code;
      default:
        return Icons.android;
    }
  }

  void _showBotEditorDialog(BuildContext context, {Bot? bot}) {
    final openRouterService =
        Provider.of<OpenRouterService>(context, listen: false);
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // Check if API key is set before proceeding
    if (!settingsProvider.hasApiKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Languages.textSetApiKeyForBots),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Get available models or use defaults if API isn't ready
    final Future<List<String>> modelsFuture = openRouterService.isInitialized
        ? openRouterService.getAvailableModels()
        : Future.value(
            ['openai/gpt-4o-mini', 'openai/gpt-4', 'anthropic/claude-2']);

    // Show loading indicator while fetching models
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(Languages.textLoadingModels),
          ],
        ),
      ),
    );

    // Once models are loaded, show the editor dialog
    modelsFuture.then((models) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        showDialog(
          context: context,
          builder: (context) => BotEditorDialog(
            bot: bot,
            availableModels: models,
          ),
        ).then((result) {
          if (result != null && context.mounted) {
            final botProvider =
                Provider.of<BotProvider>(context, listen: false);

            if (bot == null) {
              // Adding a new bot
              botProvider.addBot(result);
            } else {
              // Updating an existing bot
              botProvider.updateBot(result);
            }
          }
        });
      }
    }).catchError((error) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Languages.textErrorLoadingModels} $error'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }
}
