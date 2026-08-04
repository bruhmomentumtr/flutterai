// Default location: lib/screens/chat_screen.dart
// Main chat screen for the application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/bot_provider.dart';
import '../models/bot.dart';
import '../services/openrouter_service.dart';
import '../languages/languages.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/bot_selection.dart';
import '../widgets/bot_editor_dialog.dart';
import '../core/theme/app_spacing.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchModelsAndPricing();
    });
  }

  Future<void> _fetchModelsAndPricing() async {
    final openRouterService =
        Provider.of<OpenRouterService>(context, listen: false);
    final botProvider = Provider.of<BotProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (openRouterService.isInitialized) {
      final botsWithPricing =
          await openRouterService.getAvailableBotsWithPricing();
      if (botsWithPricing.isNotEmpty) {
        await botProvider.syncWithApiBots(botsWithPricing);
      }
    }

    if (chatProvider.selectedBot == null && botProvider.bots.isNotEmpty) {
      chatProvider.selectBot(botProvider.bots.first);
    }
  }

  void _showBotEditorDialog(BuildContext context, {Bot? bot}) {
    final botProvider = Provider.of<BotProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => BotEditorDialog(
        bot: bot,
        availableModels: botProvider.bots.map((b) => b.model).toList(),
        onSave: (savedBot) async {
          if (bot == null) {
            await botProvider.addBot(savedBot);
          } else {
            await botProvider.updateBot(savedBot);
          }
          chatProvider.selectBot(savedBot);
        },
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final botProvider = Provider.of<BotProvider>(context);

    // Ensure a default bot is selected if available
    if (chatProvider.selectedBot == null && botProvider.bots.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatProvider.selectBot(botProvider.bots.first);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chatProvider.selectedBot?.name ?? Languages.textSelectBot),
            if (chatProvider.formattedSessionCost.isNotEmpty)
              Text(
                'Yakılan: ${chatProvider.formattedSessionCost} (${chatProvider.currentSessionTotalTokens} tkn)',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () => chatProvider.startNewSession(),
            tooltip: 'Yeni Sohbet',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchModelsAndPricing(),
            tooltip: 'Bot Listesini Yenile',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: BotSelection(
              bots: botProvider.bots,
              selectedBot: chatProvider.selectedBot,
              onSelectBot: (bot) => chatProvider.selectBot(bot),
              onAddBot: () => _showBotEditorDialog(context),
              onEditBot: (bot) => _showBotEditorDialog(context, bot: bot),
            ),
          ),
          Expanded(
            child: chatProvider.messages.isEmpty
                ? Center(
                    child: Text(
                      Languages.textSendMessageToStart,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),
          MessageInput(
            onSendMessage: (content, imageFile) {
              chatProvider.sendMessage(content, imageFile: imageFile);
            },
            isLoading: chatProvider.isLoading,
          ),
        ],
      ),
    );
  }
}
