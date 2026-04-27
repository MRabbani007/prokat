import 'package:flutter/material.dart';

void showImagePickerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from gallery"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take photo"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove image"),
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
