import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EquipmentImageHeader extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onEdit;

  const EquipmentImageHeader({
    super.key,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = imageUrl?.isNotEmpty == true ? imageUrl! : testImage;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: displayUrl.isNotEmpty 
              ? CachedNetworkImage(
                  imageUrl: displayUrl,
                  fit: BoxFit.cover,
                  memCacheHeight: 600,
                  placeholder: (_, _) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, url, error) {
                    debugPrint("IMAGE ERROR: $error");
                    return _fallback();
                  },
                )
              : _fallback(),
        ),

        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.small(
            heroTag: "editImage",
            onPressed: onEdit,
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_outlined, size: 80, color: Colors.grey),
      ),
    );
  }
}
