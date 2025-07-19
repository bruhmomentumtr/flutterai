// Default location: lib/widgets/bot_icon.dart
// Custom widget to display bot icons including Flutter logo

import 'package:flutter/material.dart';
import 'material3_flutter_logo.dart';

class BotIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;
  final bool showShadow;
  final bool showAccents;

  const BotIcon({
    super.key,
    required this.iconName,
    this.size = 24.0,
    this.color,
    this.showShadow = false,
    this.showAccents = true,
  });

  @override
  Widget build(BuildContext context) {
    // Handle Flutter logo specially
    if (iconName == 'flutter') {
      return Material3FlutterLogo(
        size: size,
        showShadow: showShadow,
        showAccents: showAccents,
      );
    }
    
    // Handle regular Material icons
    final iconData = _getIconData(iconName);
    final iconColor = color ?? Theme.of(context).colorScheme.onSurface;
    
    return Icon(
      iconData,
      size: size,
      color: iconColor,
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
      case 'android':
        return Icons.android;
      case 'flutter':
        // This should not be reached as we handle flutter specially above
        return Icons.android;
      default:
        return Icons.android;
    }
  }
} 