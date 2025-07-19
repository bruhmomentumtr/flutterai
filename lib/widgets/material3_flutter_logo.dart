// Default location: lib/widgets/material3_flutter_logo.dart
// Material 3 style Flutter logo widget

import 'package:flutter/material.dart';

class Material3FlutterLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;
  final bool showShadow;
  final bool showAccents;

  const Material3FlutterLogo({
    super.key,
    this.size = 80.0,
    this.primaryColor,
    this.accentColor,
    this.showShadow = true,
    this.showAccents = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.colorScheme.primary;
    final accent = accentColor ?? theme.colorScheme.primaryContainer;
    
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Material3FlutterLogoPainter(
          primaryColor: primary,
          accentColor: accent,
          showShadow: showShadow,
          showAccents: showAccents,
        ),
      ),
    );
  }
}

class _Material3FlutterLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool showShadow;
  final bool showAccents;

  _Material3FlutterLogoPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.showShadow,
    required this.showAccents,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Create gradient for background
    final gradient = RadialGradient(
      center: Alignment.topLeft,
      radius: 1.2,
      colors: [
        primaryColor,
        primaryColor.withOpacity(0.8),
      ],
    );
    
    // Draw background circle with Material 3 styling
    final backgroundPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    
    // Add shadow if enabled
    if (showShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawCircle(center, radius - 4, shadowPaint);
    }
    
    // Draw main background
    canvas.drawCircle(center, radius - 8, backgroundPaint);
    
    // Draw inner circle for depth
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius - 16, innerPaint);
    
    // Draw Flutter F symbol
    _drawFlutterF(canvas, center, radius);
    
    // Draw Material 3 accent elements
    if (showAccents) {
      _drawAccents(canvas, center, radius);
    }
  }

  void _drawFlutterF(Canvas canvas, Offset center, double radius) {
    final fPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Calculate F dimensions based on radius
    final fWidth = radius * 0.6;
    final fHeight = radius * 0.8;
    final strokeWidth = radius * 0.08;
    
    // Create F path with rounded corners
    final path = Path();
    
    // Main vertical stroke
    path.moveTo(center.dx - fWidth / 2, center.dy - fHeight / 2);
    path.lineTo(center.dx - fWidth / 2 + strokeWidth, center.dy - fHeight / 2);
    path.lineTo(center.dx - fWidth / 2 + strokeWidth, center.dy + fHeight / 2);
    path.lineTo(center.dx - fWidth / 2, center.dy + fHeight / 2);
    path.close();
    
    // Top horizontal stroke
    path.moveTo(center.dx - fWidth / 2, center.dy - fHeight / 2);
    path.lineTo(center.dx + fWidth / 2, center.dy - fHeight / 2);
    path.lineTo(center.dx + fWidth / 2, center.dy - fHeight / 2 + strokeWidth);
    path.lineTo(center.dx - fWidth / 2 + strokeWidth, center.dy - fHeight / 2 + strokeWidth);
    path.close();
    
    // Middle horizontal stroke
    path.moveTo(center.dx - fWidth / 2, center.dy - fHeight / 6);
    path.lineTo(center.dx + fWidth / 3, center.dy - fHeight / 6);
    path.lineTo(center.dx + fWidth / 3, center.dy - fHeight / 6 + strokeWidth);
    path.lineTo(center.dx - fWidth / 2 + strokeWidth, center.dy - fHeight / 6 + strokeWidth);
    path.close();
    
    canvas.drawPath(path, fPaint);
  }

  void _drawAccents(Canvas canvas, Offset center, double radius) {
    final accentPaint = Paint()
      ..color = accentColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Draw accent circles
    final accentRadius = radius * 0.08;
    
    // Top left accent
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.4),
      accentRadius,
      accentPaint,
    );
    
    // Top right accent
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.4),
      accentRadius * 0.7,
      accentPaint,
    );
    
    // Bottom left accent
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy + radius * 0.4),
      accentRadius * 1.2,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _Material3FlutterLogoPainter &&
           (oldDelegate.primaryColor != primaryColor ||
            oldDelegate.accentColor != accentColor ||
            oldDelegate.showShadow != showShadow ||
            oldDelegate.showAccents != showAccents);
  }
} 