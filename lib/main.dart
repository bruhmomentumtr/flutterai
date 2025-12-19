import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'providers/chat_provider.dart';
import 'providers/bot_provider.dart';
import 'providers/settings_provider.dart';
import 'services/openrouter_service.dart';
import 'screens/chat_screen.dart';
import 'screens/welcome_screen.dart';
import 'languages/languages.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Turkish locale
  await initializeDateFormatting('tr_TR', null);

  // Initialize services
  final openRouterService = OpenRouterService();

  // Create and initialize providers
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  // Initialize OpenRouter service with API key from settings
  if (settingsProvider.hasApiKey) {
    openRouterService.initialize(settingsProvider.apiKey);
  }

  // Create and initialize bot provider
  final botProvider = BotProvider();
  await botProvider.initializeBots();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<BotProvider>.value(value: botProvider),
        Provider<OpenRouterService>.value(value: openRouterService),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) =>
              ChatProvider(openRouterService, settingsProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: Languages.appTitleMain,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: settings.hasApiKey ? const ChatScreen() : const WelcomeScreen(),
        );
      },
    );
  }
}
