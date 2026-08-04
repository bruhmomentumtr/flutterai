// lib/screens/welcome_screen.dart
// Modern welcome screen with gradient background and glassmorphism design

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'chat_screen.dart';
import '../languages/languages.dart';
import '../core/theme/app_spacing.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final _apiKeyController = TextEditingController();
  bool _isObscureText = true;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.primary.withAlpha(77),
                  ]
                : [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xxl),

                  // Animated logo and title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildHeader(context, isDark),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Glassmorphism card with API key input
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildApiKeyCard(context, isDark),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Features list
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildFeatures(context),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Animated logo with gradient
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(102),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.auto_awesome,
            size: 50,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // App title
        Text(
          'FlutterAI',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Subtitle
        Text(
          Languages.appSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildApiKeyCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withAlpha(77) : Colors.white.withAlpha(51),
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color:
              isDark ? Colors.white.withAlpha(26) : Colors.white.withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: const Icon(
                  Icons.key_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Languages.labelApiKey,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // API Key input field
          TextField(
            controller: _apiKeyController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: Languages.hintApiKey,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMd,
                borderSide: BorderSide(color: theme.colorScheme.error),
              ),
              prefixIcon: Icon(
                Icons.vpn_key_outlined,
                color: Colors.white.withAlpha(178),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withAlpha(178),
                ),
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
              ),
              errorText: _errorMessage,
              errorStyle: TextStyle(color: theme.colorScheme.error),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            obscureText: _isObscureText,
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() {
                  _errorMessage = null;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Info text
          Text(
            Languages.apiKeyInfo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveApiKey,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Languages.buttonContinue,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Skip button
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.7),
              ),
              child: const Text(Languages.buttonSkip),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    final features = [
      {'icon': Icons.psychology_outlined, 'text': 'Multiple AI Models'},
      {'icon': Icons.lock_outline, 'text': 'Privacy First'},
      {'icon': Icons.bolt_outlined, 'text': 'Fast & Reliable'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feature['icon'] as IconData,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                feature['text'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _saveApiKey() {
    final apiKey = _apiKeyController.text.trim();

    if (apiKey.isEmpty) {
      setState(() {
        _errorMessage = Languages.errorEnterApiKey;
      });
      return;
    }

    // API anahtarı format kontrolü
    if (!apiKey.startsWith('sk-')) {
      setState(() {
        _errorMessage = Languages.errorInvalidApiKey;
      });
      return;
    }

    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // API anahtarını kaydet
    settingsProvider.setApiKey(apiKey);

    // Başarı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(Languages.successApiKeySaved),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Chat ekranına yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }
}
