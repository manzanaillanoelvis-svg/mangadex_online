import 'package:flutter/material.dart';
class MangaCard extends StatelessWidget {
  final String title; final String imageUrl; final String? badge; final VoidCallback? onTap; final VoidCallback? onLongPress;
  const MangaCard({super.key, required this.title, required this.imageUrl, this.badge, this.onTap, this.onLongPress});
  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap, onLongPress: onLongPress,
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 3/4, child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
        if (badge != null) Positioned(
          top: 10, left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.6)),
            ),
            child: Text(badge!, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        Positioned(left: 12, right: 12, bottom: 12,
          child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, shadows: [Shadow(blurRadius: 8, color: Colors.black54)])),
        ),
      ]),
    );
  }
}