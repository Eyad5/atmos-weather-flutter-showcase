import 'dart:math' as math;

import 'package:flutter/material.dart';

class WeatherIllustration extends StatelessWidget {
  final int conditionCode;
  final String iconUrl;
  final double size;

  const WeatherIllustration({
    super.key,
    required this.conditionCode,
    this.iconUrl = '',
    this.size = 120,
  });

  static const Set<int> _snowCodes = {
    1066,
    1069,
    1072,
    1114,
    1117,
    1204,
    1207,
    1210,
    1213,
    1216,
    1219,
    1222,
    1225,
    1237,
    1249,
    1252,
    1255,
    1258,
    1261,
    1264,
  };

  static const Set<int> _rainCodes = {
    1063,
    1150,
    1153,
    1168,
    1171,
    1180,
    1183,
    1186,
    1189,
    1192,
    1195,
    1198,
    1201,
    1240,
    1243,
    1246,
  };

  static const Set<int> _stormCodes = {
    1087,
    1273,
    1274,
    1275,
    1276,
    1277,
    1278,
    1279,
    1280,
    1281,
    1282,
  };

  static const Set<int> _fogCodes = {1030, 1135, 1147};

  _WeatherType get _type {
    final isNight = iconUrl.contains('/night/');
    if (isNight) return _WeatherType.night;
    if (conditionCode == 1000) return _WeatherType.sunny;
    if (conditionCode == 1003) return _WeatherType.partlyCloudy;
    if (conditionCode == 1006 || conditionCode == 1009) {
      return _WeatherType.cloudy;
    }
    if (_fogCodes.contains(conditionCode)) return _WeatherType.foggy;
    if (_stormCodes.contains(conditionCode)) return _WeatherType.stormy;
    if (_snowCodes.contains(conditionCode)) return _WeatherType.snowy;
    if (_rainCodes.contains(conditionCode)) return _WeatherType.rainy;
    return _WeatherType.defaultCloud;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _WeatherPainter(type: _type),
      ),
    );
  }
}

enum _WeatherType {
  sunny,
  partlyCloudy,
  cloudy,
  rainy,
  stormy,
  snowy,
  foggy,
  night,
  defaultCloud,
}

class _WeatherPainter extends CustomPainter {
  final _WeatherType type;

  _WeatherPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case _WeatherType.sunny:
        _drawSun(canvas, size);
      case _WeatherType.partlyCloudy:
        _drawPartlyCloudy(canvas, size);
      case _WeatherType.cloudy:
        _drawCloudy(canvas, size);
      case _WeatherType.rainy:
        _drawRainy(canvas, size);
      case _WeatherType.stormy:
        _drawStormy(canvas, size);
      case _WeatherType.snowy:
        _drawSnowy(canvas, size);
      case _WeatherType.foggy:
        _drawFoggy(canvas, size);
      case _WeatherType.night:
        _drawNight(canvas, size);
      case _WeatherType.defaultCloud:
        _drawDefaultCloud(canvas, size);
    }
  }

  void _drawSun(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.22;

    // Draw rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final innerR = radius + size.width * 0.06;
      final outerR = radius + size.width * 0.14;
      final start = Offset(
        center.dx + innerR * math.cos(angle),
        center.dy + innerR * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerR * math.cos(angle),
        center.dy + outerR * math.sin(angle),
      );
      canvas.drawLine(start, end, rayPaint);
    }

    // Draw sun body with gradient
    final sunGradient = RadialGradient(
      colors: [
        const Color(0xFFFDE68A),
        const Color(0xFFF59E0B),
        const Color(0xFFD97706),
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    final sunPaint = Paint()
      ..shader = sunGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawCircle(center, radius, sunPaint);

    // Inner highlight
    final highlightPaint = Paint()..color = const Color(0x40FFFFFF);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
      radius * 0.4,
      highlightPaint,
    );
  }

  void _drawPartlyCloudy(Canvas canvas, Size size) {
    // Draw smaller sun behind cloud
    final sunCenter = Offset(size.width * 0.62, size.height * 0.3);
    final sunRadius = size.width * 0.15;

    final rayPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * math.pi / 180;
      final start = Offset(
        sunCenter.dx + (sunRadius + size.width * 0.03) * math.cos(angle),
        sunCenter.dy + (sunRadius + size.width * 0.03) * math.sin(angle),
      );
      final end = Offset(
        sunCenter.dx + (sunRadius + size.width * 0.09) * math.cos(angle),
        sunCenter.dy + (sunRadius + size.width * 0.09) * math.sin(angle),
      );
      canvas.drawLine(start, end, rayPaint);
    }

    final sunGradient = RadialGradient(
      colors: [const Color(0xFFFDE68A), const Color(0xFFF59E0B)],
    );
    final sunPaint = Paint()
      ..shader = sunGradient.createShader(
        Rect.fromCircle(center: sunCenter, radius: sunRadius),
      );
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // Draw cloud in front
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.42, size.height * 0.52),
      size.width * 0.42,
      const Color(0xFFE2E8F0),
      const Color(0xFFF1F5F9),
    );
  }

  void _drawCloudy(Canvas canvas, Size size) {
    // Back cloud (darker, offset)
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.52, size.height * 0.38),
      size.width * 0.34,
      const Color(0xFFCBD5E1),
      const Color(0xFFE2E8F0),
    );

    // Front cloud (lighter)
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.40, size.height * 0.55),
      size.width * 0.42,
      const Color(0xFFE2E8F0),
      const Color(0xFFF8FAFC),
    );
  }

  void _drawRainy(Canvas canvas, Size size) {
    // Cloud
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.45, size.height * 0.35),
      size.width * 0.38,
      const Color(0xFF94A3B8),
      const Color(0xFFCBD5E1),
    );

    // Rain lines
    final rainPaint = Paint()
      ..color = const Color(0xFF60A5FA)
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    final rainDrops = [
      [0.28, 0.60, 0.25, 0.75],
      [0.42, 0.62, 0.39, 0.78],
      [0.56, 0.58, 0.53, 0.73],
      [0.35, 0.68, 0.32, 0.83],
      [0.50, 0.70, 0.47, 0.85],
      [0.63, 0.65, 0.60, 0.80],
    ];

    for (final drop in rainDrops) {
      canvas.drawLine(
        Offset(size.width * drop[0], size.height * drop[1]),
        Offset(size.width * drop[2], size.height * drop[3]),
        rainPaint,
      );
    }
  }

  void _drawStormy(Canvas canvas, Size size) {
    // Dark cloud
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.45, size.height * 0.32),
      size.width * 0.40,
      const Color(0xFF475569),
      const Color(0xFF64748B),
    );

    // Lightning bolt
    final lightningPath = Path();
    lightningPath.moveTo(size.width * 0.48, size.height * 0.48);
    lightningPath.lineTo(size.width * 0.40, size.height * 0.62);
    lightningPath.lineTo(size.width * 0.48, size.height * 0.60);
    lightningPath.lineTo(size.width * 0.42, size.height * 0.80);
    lightningPath.lineTo(size.width * 0.56, size.height * 0.58);
    lightningPath.lineTo(size.width * 0.49, size.height * 0.60);
    lightningPath.lineTo(size.width * 0.55, size.height * 0.48);
    lightningPath.close();

    // Lightning glow
    final glowPaint = Paint()
      ..color = const Color(0x60FBBF24)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(lightningPath, glowPaint);

    // Lightning fill
    final lightningPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawPath(lightningPath, lightningPaint);
  }

  void _drawSnowy(Canvas canvas, Size size) {
    // Cloud
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.45, size.height * 0.32),
      size.width * 0.38,
      const Color(0xFFCBD5E1),
      const Color(0xFFE2E8F0),
    );

    // Snowflake dots
    final snowPaint = Paint()..color = const Color(0xFFBFDBFE);

    final snowPositions = [
      [0.28, 0.60],
      [0.42, 0.65],
      [0.55, 0.58],
      [0.35, 0.74],
      [0.50, 0.78],
      [0.62, 0.70],
      [0.30, 0.85],
      [0.45, 0.88],
      [0.58, 0.84],
    ];

    final dotRadius = size.width * 0.025;
    for (final pos in snowPositions) {
      canvas.drawCircle(
        Offset(size.width * pos[0], size.height * pos[1]),
        dotRadius,
        snowPaint,
      );
    }

    // Add tiny cross lines on some snowflakes for detail
    final crossPaint = Paint()
      ..color = const Color(0xFF93C5FD)
      ..strokeWidth = size.width * 0.008
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < snowPositions.length; i += 2) {
      final cx = size.width * snowPositions[i][0];
      final cy = size.height * snowPositions[i][1];
      final cr = dotRadius * 1.2;
      canvas.drawLine(Offset(cx - cr, cy), Offset(cx + cr, cy), crossPaint);
      canvas.drawLine(Offset(cx, cy - cr), Offset(cx, cy + cr), crossPaint);
    }
  }

  void _drawFoggy(Canvas canvas, Size size) {
    final fogPaint = Paint()
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final lines = [
      [0.20, 0.28, 0.80, 0.28, 0xFFA0AEC0],
      [0.15, 0.40, 0.85, 0.40, 0xFF94A3B8],
      [0.22, 0.52, 0.78, 0.52, 0xFFCBD5E1],
      [0.18, 0.64, 0.82, 0.64, 0xFF94A3B8],
      [0.25, 0.76, 0.75, 0.76, 0xFFCBD5E1],
    ];

    for (final line in lines) {
      fogPaint.color = Color(line[4].toInt());

      final path = Path();
      final startX = size.width * line[0];
      final endX = size.width * line[2];
      final y = size.height * line[1];
      final waveHeight = size.height * 0.02;
      final segmentWidth = (endX - startX) / 4;

      path.moveTo(startX, y);
      for (int i = 0; i < 4; i++) {
        final x1 = startX + segmentWidth * i + segmentWidth * 0.5;
        final y1 = y + (i.isEven ? -waveHeight : waveHeight);
        final x2 = startX + segmentWidth * (i + 1);
        path.quadraticBezierTo(x1, y1, x2, y);
      }

      canvas.drawPath(path, fogPaint);
    }
  }

  void _drawNight(Canvas canvas, Size size) {
    // Crescent moon
    final moonCenter = Offset(size.width * 0.45, size.height * 0.42);
    final moonRadius = size.width * 0.2;

    // Moon glow
    final glowGradient = RadialGradient(
      colors: [const Color(0x30FBBF24), const Color(0x00FBBF24)],
    );
    final glowPaint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(center: moonCenter, radius: moonRadius * 1.8),
      );
    canvas.drawCircle(moonCenter, moonRadius * 1.8, glowPaint);

    // Moon body
    final moonGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: [const Color(0xFFFDE68A), const Color(0xFFFBBF24)],
    );
    final moonPaint = Paint()
      ..shader = moonGradient.createShader(
        Rect.fromCircle(center: moonCenter, radius: moonRadius),
      );
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);

    // Crescent cutout
    final cutoutPaint = Paint()..blendMode = BlendMode.dstOut;
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);
    canvas.drawCircle(
      Offset(
        moonCenter.dx + moonRadius * 0.5,
        moonCenter.dy - moonRadius * 0.3,
      ),
      moonRadius * 0.75,
      cutoutPaint,
    );
    canvas.restore();

    // Stars
    final starPaint = Paint()..color = const Color(0xFFE2E8F0);
    final stars = [
      [0.72, 0.22, 0.020],
      [0.82, 0.38, 0.015],
      [0.18, 0.28, 0.018],
      [0.75, 0.58, 0.012],
      [0.25, 0.65, 0.014],
      [0.85, 0.70, 0.010],
      [0.15, 0.50, 0.012],
    ];

    for (final star in stars) {
      final sx = size.width * star[0];
      final sy = size.height * star[1];
      final sr = size.width * star[2];
      canvas.drawCircle(Offset(sx, sy), sr, starPaint);

      // Cross sparkle
      final sparklePaint = Paint()
        ..color = const Color(0x80E2E8F0)
        ..strokeWidth = size.width * 0.005
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(sx - sr * 1.5, sy),
        Offset(sx + sr * 1.5, sy),
        sparklePaint,
      );
      canvas.drawLine(
        Offset(sx, sy - sr * 1.5),
        Offset(sx, sy + sr * 1.5),
        sparklePaint,
      );
    }
  }

  void _drawDefaultCloud(Canvas canvas, Size size) {
    _drawCloudShape(
      canvas,
      Offset(size.width * 0.45, size.height * 0.50),
      size.width * 0.40,
      const Color(0xFFCBD5E1),
      const Color(0xFFE2E8F0),
    );
  }

  void _drawCloudShape(
    Canvas canvas,
    Offset center,
    double cloudWidth,
    Color darkColor,
    Color lightColor,
  ) {
    final cw = cloudWidth;
    final ch = cw * 0.55;

    // Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x18000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final shadowPath = _buildCloudPath(
      Offset(center.dx + 2, center.dy + 3),
      cw,
      ch,
    );
    canvas.drawPath(shadowPath, shadowPaint);

    // Cloud body gradient
    final rect = Rect.fromCenter(
      center: center,
      width: cw * 1.2,
      height: ch * 1.6,
    );
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [lightColor, darkColor],
    );
    final cloudPaint = Paint()..shader = gradient.createShader(rect);

    final cloudPath = _buildCloudPath(center, cw, ch);
    canvas.drawPath(cloudPath, cloudPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = const Color(0x20FFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final highlightPath = _buildCloudPath(
      Offset(center.dx, center.dy - ch * 0.08),
      cw * 0.85,
      ch * 0.7,
    );
    canvas.drawPath(highlightPath, highlightPaint);
  }

  Path _buildCloudPath(Offset center, double w, double h) {
    final path = Path();
    final baseY = center.dy + h * 0.25;

    // Bottom flat-ish base
    path.moveTo(center.dx - w * 0.42, baseY);

    // Left bump
    path.arcTo(
      Rect.fromCenter(
        center: Offset(center.dx - w * 0.28, center.dy + h * 0.05),
        width: w * 0.32,
        height: h * 0.55,
      ),
      math.pi * 0.7,
      -math.pi * 0.85,
      false,
    );

    // Top-left bump
    path.arcTo(
      Rect.fromCenter(
        center: Offset(center.dx - w * 0.08, center.dy - h * 0.18),
        width: w * 0.38,
        height: h * 0.65,
      ),
      math.pi * 0.8,
      -math.pi * 0.9,
      false,
    );

    // Top-right bump (tallest)
    path.arcTo(
      Rect.fromCenter(
        center: Offset(center.dx + w * 0.14, center.dy - h * 0.12),
        width: w * 0.36,
        height: h * 0.7,
      ),
      math.pi * 0.9,
      -math.pi * 0.95,
      false,
    );

    // Right bump
    path.arcTo(
      Rect.fromCenter(
        center: Offset(center.dx + w * 0.30, center.dy + h * 0.05),
        width: w * 0.28,
        height: h * 0.5,
      ),
      -math.pi * 0.3,
      -math.pi * 0.7,
      false,
    );

    path.lineTo(center.dx + w * 0.42, baseY);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _WeatherPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
