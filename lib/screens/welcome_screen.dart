// Default location: lib/screens/welcome_screen.dart
// Welcome screen to collect API key before starting the app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'chat_screen.dart';

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
              const Icon(
                Icons.chat_rounded,
                size: 80.0,
                color: Colors.blue,
              ),
              const SizedBox(height: 16.0),
              Text(
                'OpenRouter Sohbet Uygulaması',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Başlamak için OpenRouter API anahtarını girin',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              
              // API key input
              TextField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  labelText: 'OpenRouter API Anahtarı',
                  hintText: 'sk-...',
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
                'API anahtarınız cihazınızda güvenli bir şekilde saklanacak ve sadece OpenRouter servisleriyle iletişim için kullanılacaktır.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveApiKey,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Devam Et',
                      style: TextStyle(fontSize: 16.0),
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
                child: const Text('Şimdilik Atla (Test için)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveApiKey() {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir API anahtarı girin'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // API anahtarı format kontrolü
    if (!apiKey.startsWith('sk-')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçersiz API anahtarı formatı. OpenRouter anahtarları "sk-" ile başlamalıdır.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // API anahtarını kaydet ve doğrudan ChatScreen'e yönlendir
    // API testi yapmak yerine hemen anahtarı kaydedip devam edelim
    
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    // API anahtarını kaydet
    settingsProvider.setApiKey(apiKey);
    
    // Başarı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API anahtarı başarıyla kaydedildi'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Doğrudan chat ekranına yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }
} 