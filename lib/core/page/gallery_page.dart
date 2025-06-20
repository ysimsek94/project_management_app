import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/services/photo_picker_service.dart';
import 'package:project_management_app/core/services/photo_upload_service.dart';
import 'package:project_management_app/injection.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:project_management_app/core/widgets/app_custom_app_bar.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<File> _images = [];

  Future<void> _pickImageFromGallery() async {
    final image = await PhotoPickerService.pickImage(fromCamera: false,context: context);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
      await _handleUpload(image);
    } else {
      AppAlerts.showWarning(context, "Fotoğraf seçilemedi veya izin verilmedi.");
    }
  }

  Future<void> _takePhoto() async {
    final image = await PhotoPickerService.pickImage(fromCamera: true,context: context);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
      await _handleUpload(image);
    } else {
      AppAlerts.showWarning(context, "Kamera izni verilmedi veya işlem iptal edildi.");
    }
  }

  Future<void> _handleUpload(File image) async {
    await getIt<PhotoUploadService>().uploadImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Galeri',
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            tooltip: 'Fotoğraf Çek',
            onPressed: _takePhoto,
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: 'Galeriden Yükle',
            onPressed: _pickImageFromGallery,
          ),
        ],
      ),
      body: _images.isEmpty
          ? const Center(child: Text('Henüz fotoğraf yok'))
          : GridView.builder(
              padding: EdgeInsets.all(12.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12.w,
                crossAxisSpacing: 12.w,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Center(
                          child: Material(
                            color: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.file(
                                _images[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
