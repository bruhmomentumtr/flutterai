import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'providers/chat_provider.dart';
import 'providers/bot_provider.dart';
import 'providers/settings_provider.dart';
import 'services/openrouter_service.dart';
import 'services/network_service.dart';
import 'screens/chat_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/network_error_screen.dart';
import 'languages/languages.dart';

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
  final botProvider = BotProvider(settingsProvider);
  await botProvider.initializeBots();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<BotProvider>.value(value: botProvider),
        Provider<OpenRouterService>.value(value: openRouterService),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(openRouterService, settingsProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCheckingConnection = true;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isCheckingConnection = true;
    });

    try {
      final isConnected = await NetworkService.isConnected();

      setState(() {
        _isCheckingConnection = false;
        _hasConnection = isConnected;
      });
    } catch (e) {
      debugPrint(Languages.msgConnectionErrorDebug + e.toString());
      // Hata durumunda varsayılan olarak bağlantı olduğunu kabul edelim
      // Böylece uygulama başlangıçta takılıp kalmaz
      setState(() {
        _isCheckingConnection = false;
        _hasConnection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return MaterialApp(
              title: Languages.appTitleMain,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkDynamic ?? ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              themeMode: settings.themeMode,
              home: settings.hasApiKey ? const ChatScreen() : const WelcomeScreen(),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              Languages.msgCheckingConnection,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
