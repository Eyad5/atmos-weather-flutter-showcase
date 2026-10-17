import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconUrl;
  final double size;

  const WeatherIcon({super.key, required this.iconUrl, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: SizedBox(
              width: size * 0.4,
              height: size * 0.4,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (_, _, _) => Icon(
        Icons.cloud_outlined,
        size: size,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
