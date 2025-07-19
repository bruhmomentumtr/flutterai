// Default location: lib/screens/welcome_screen.dart
// Giriş ekranında API anahtarı test mekanizması

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/api_settings_provider.dart'; // Added this import
import 'chat_screen.dart';
import '../languages/languages.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _apiKeyController = TextEditingController();
  bool _isObscureText = true;
  String? _errorMessage;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo and title
              Icon(
                Icons.chat_rounded,
                size: 80.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16.0),
              Text(
                Languages.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                Languages.appSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              
              // API key input
              Consumer<ApiSettingsProvider>(
                builder: (context, apiSettings, child) {
                  return Column(
                    children: [
                      TextField(
                        controller: _apiKeyController,
                        decoration: InputDecoration(
                          labelText: Languages.labelApiKey,
                          hintText: Languages.hintApiKey,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureText = !_isObscureText;
                              });
                            },
                          ),
                          errorText: _errorMessage,
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
                      const SizedBox(height: 8.0),
                      Text(
                        Languages.apiKeyInfo,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: apiSettings.isTesting
                              ? null
                              : () async {
                                  final apiKey = _apiKeyController.text.trim();
                                  
                                  if (apiKey.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(Languages.msgEnterApiKey),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  // API anahtarı format kontrolü
                                  if (!apiKey.startsWith('sk-')) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(Languages.msgInvalidApiKey),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  await apiSettings.setApiKeyAndTest(apiKey);
                                  if (apiSettings.selectedEndpoint != null) {
                                    // Başarılıysa ana ekrana yönlendir
                                    Navigator.pushReplacementNamed(context, '/main');
                                  }
                                  // Başarısızsa mesaj zaten görünecek
                                },
                          child: apiSettings.isTesting
                              ? const CircularProgressIndicator()
                              : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  Languages.buttonContinue,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      // Skip for now (debug only)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const ChatScreen()),
                          );
                        },
                        child: Text(Languages.buttonSkip),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 