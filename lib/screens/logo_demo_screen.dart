// Default location: lib/screens/logo_demo_screen.dart
// Demo screen to showcase Material 3 Flutter logo

import 'package:flutter/material.dart';
import '../widgets/material3_flutter_logo.dart';
import '../widgets/bot_icon.dart';

class LogoDemoScreen extends StatelessWidget {
  const LogoDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Flutter Logo Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Material 3 Flutter Logo in different sizes
            _buildSection(
              context,
              'Material 3 Flutter Logo',
              [
                const Material3FlutterLogo(size: 40),
                const SizedBox(width: 16),
                const Material3FlutterLogo(size: 60),
                const SizedBox(width: 16),
                const Material3FlutterLogo(size: 80),
                const SizedBox(width: 16),
                const Material3FlutterLogo(size: 100),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Bot Icon with Flutter logo
            _buildSection(
              context,
              'Bot Icon with Flutter Logo',
              [
                BotIcon(iconName: 'flutter', size: 40),
                const SizedBox(width: 16),
                BotIcon(iconName: 'flutter', size: 60),
                const SizedBox(width: 16),
                BotIcon(iconName: 'flutter', size: 80),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Different configurations
            _buildSection(
              context,
              'Different Configurations',
              [
                const Material3FlutterLogo(size: 60, showShadow: false),
                const SizedBox(width: 16),
                const Material3FlutterLogo(size: 60, showAccents: false),
                const SizedBox(width: 16),
                const Material3FlutterLogo(size: 60, showShadow: true, showAccents: true),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Comparison with regular icons
            _buildSection(
              context,
              'Comparison with Regular Icons',
              [
                BotIcon(iconName: 'chat', size: 40),
                const SizedBox(width: 16),
                BotIcon(iconName: 'smart_toy', size: 40),
                const SizedBox(width: 16),
                BotIcon(iconName: 'flutter', size: 40),
                const SizedBox(width: 16),
                BotIcon(iconName: 'edit', size: 40),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Material 3 design principles info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material 3 Design Principles',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Rounded corners and soft shadows\n'
                      '• Gradient backgrounds with depth\n'
                      '• Consistent color scheme integration\n'
                      '• Scalable and accessible design\n'
                      '• Modern elevation and layering',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: children,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
} 