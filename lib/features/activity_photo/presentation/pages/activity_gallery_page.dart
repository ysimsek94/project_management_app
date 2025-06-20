
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart' as p;
import 'package:project_management_app/core/page/base_page.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/services/photo_picker_service.dart';
import '../../../../core/widgets/app_alerts.dart';
import '../../../../core/widgets/app_custom_app_bar.dart';
import '../../data/models/activity_photo_model.dart';
import '../bloc/activity_photo_cubit.dart';
import '../bloc/activity_photo_state.dart';

class ActivityGalleryPage extends StatefulWidget {
  final FaliyetResponseModel activityItemRequestModel;
  const ActivityGalleryPage({Key? key, required this.activityItemRequestModel}) : super(key: key);

  @override
  State<ActivityGalleryPage> createState() => _ActivityGalleryPageState();
}

class _ActivityGalleryPageState extends State<ActivityGalleryPage> {
  @override
  void initState() {
    super.initState();
    // Sayfa açılınca fazId, gorevId ve loadImage ile fotoğrafları yükle
    context.read<ActivityPhotoCubit>().loadPhotos(
      fazId: widget.activityItemRequestModel.faliyetGorev.faliyetId,
      gorevId: widget.activityItemRequestModel.faliyetGorev.id,
      loadImage: false,
    );
  }

  /// Builds a circular icon + label card for the action sheet
  Widget _buildActionCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(bool fromCamera) async {
    final file = await PhotoPickerService.pickImage(fromCamera: fromCamera,context:context);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    // Derive the file name and extension
    final fileName = p.basename(file.path);
    final fileExtension = p.extension(file.path).replaceFirst('.', '');

    final base64 = base64Encode(bytes);

    try {
      await context.read<ActivityPhotoCubit>().upload(
        ActivityPhotoModel(
          id:0,
          faliyetId: widget.activityItemRequestModel.faliyetId,
          gorevId: widget.activityItemRequestModel.faliyetGorev.id,
          docBinary: base64,
          thumbnailBinary: base64,
          kayitEden: AppPreferences.username ?? '',
          islemTarihi: DateTime.now().toIso8601String(),
          docName: fileName,
          uzanti: fileExtension,
          aciklama: '',
        ),
      );
      AppAlerts.showSuccess(context, 'Fotoğraf yüklendi.');
    } catch (_) {
      // Hata state listener tarafından gösterilecek
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        title: 'Fotoğraflar',
        showBackButton: true,

      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionCard(
                      Icons.camera_alt,
                      'Kamera',
                      () {
                        Navigator.pop(context);
                        _pickAndUpload(true);
                      },
                    ),
                    _buildActionCard(
                      Icons.photo_library,
                      'Galeriden',
                      () {
                        Navigator.pop(context);
                        _pickAndUpload(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Fotoğraf Ekle',
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      child: BlocConsumer<ActivityPhotoCubit, ActivityPhotoState>(
        listener: (context, state) {
          if (state is ActivityPhotoError) {
            AppAlerts.showError(context, state.message);
          }
        },
        builder: (context, state) {
          // During initial load (no photos yet), show only spinner
          if (state is ActivityPhotoLoading && (state.photos.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }
          final photos = state is ActivityPhotoLoaded
              ? state.photos
              : state is ActivityPhotoLoading
                  ? state.photos
                  : <ActivityPhotoModel>[];

          // After load, if loaded but still empty, show no-photos message
          if (state is ActivityPhotoLoaded && photos.isEmpty) {
            return const Center(child: Text('Fotoğraf bulunamadı.'));
          }

          return Stack(
            children: [
              if (photos.isNotEmpty)
                GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    final widgetImage = photo.thumbnailBinary.startsWith('http')
                        ? Image.network(photo.thumbnailBinary, fit: BoxFit.cover)
                        : Image.memory(
                            base64Decode(photo.thumbnailBinary),
                            fit: BoxFit.cover,
                          );

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                PhotoView(
                                  imageProvider: photo.thumbnailBinary.startsWith('http')
                                      ? NetworkImage(photo.thumbnailBinary)
                                      : MemoryImage(base64Decode(photo.thumbnailBinary)) as ImageProvider,
                                  backgroundDecoration: BoxDecoration(color: Colors.black87),
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale: PhotoViewComputedScale.covered * 2,
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(Icons.close, color: Colors.white, size: 24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(child: widgetImage),
                          Positioned(
                            top: 1,
                            right: 4,
                            child: IconButton(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              iconSize: 16,
                              color: Colors.white,
                              icon: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.delete, size: 24, color: Colors.white),
                              ),
                              onPressed: () async {
                                final ok = await AppAlerts.showConfirmationDialog(
                                  context,
                                  title: 'Silmek istiyor musunuz?',
                                  confirmText: "Sil",
                                  cancelText: "Kapat",
                                );
                                if (!ok) return;
                                await context.read<ActivityPhotoCubit>().delete(photo.id);
                                AppAlerts.showSuccess(context, 'Fotoğraf silindi.');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (state is ActivityPhotoLoading)
                Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}