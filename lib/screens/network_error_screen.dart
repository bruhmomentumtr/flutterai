// Default location: lib/screens/network_error_screen.dart
// Network error screen to display when there is no internet connection

import 'package:flutter/material.dart';
import '../services/network_service.dart';

// User-facing text messages
const String _textConnectionError = 'Bağlantı Hatası';
const String _textNoInternet = 'İnternet bağlantısı bulunamadı';
const String _textCheckConnection = 'Uygulamanın çalışması için internet bağlantısı gereklidir. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.';
const String _textChecking = 'Kontrol ediliyor...';
const String _textRetry = 'Tekrar Dene';

class NetworkErrorScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NetworkErrorScreen({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  State<NetworkErrorScreen> createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _diagnostics = {};

  Future<void> _checkConnection() async {
    setState(() {
      _isLoading = true;
    });

    final isConnected = await NetworkService.isConnected();
    final diagnostics = await NetworkService.getDiagnostics();

    setState(() {
      _isLoading = false;
      _diagnostics = diagnostics;
    });

    if (isConnected) {
      widget.onRetry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_textConnectionError),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.signal_wifi_off,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                _textNoInternet,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                _textCheckConnection,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _isLoading ? null : _checkConnection,
                icon: _isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? _textChecking : _textRetry),
              ),
              if (_diagnostics.isNotEmpty) ...[
                const SizedBox(height: 40),
                const Text(
                  'Tanı Bilgileri:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _diagnostics.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 