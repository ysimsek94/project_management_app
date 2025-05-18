import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/services/photo_picker_service.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import '../bloc/task_photo_cubit.dart';
import '../bloc/task_photo_state.dart';

class TaskGalleryPage extends StatefulWidget {
  final String taskId;
  const TaskGalleryPage({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskGalleryPage> createState() => _TaskGalleryPageState();
}

class _TaskGalleryPageState extends State<TaskGalleryPage> {
  @override
  void initState() {
    super.initState();
    // Sayfa açılınca taskId ile fotoğrafları yükle
    context.read<TaskPhotoCubit>().loadPhotos(widget.taskId);
  }

  Future<void> _pickAndUpload(bool fromCamera) async {
    final file = await PhotoPickerService.pickImage(fromCamera: fromCamera);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);

    try {
      await context.read<TaskPhotoCubit>().upload(widget.taskId, base64);
      AppAlerts.showSuccess(context, 'Fotoğraf yüklendi.');
    } catch (_) {
      // Hata state listener tarafından gösterilecek
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fotoğraflar')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            child: const Icon(Icons.camera_alt),
            onPressed: () => _pickAndUpload(true),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'gallery',
            child: const Icon(Icons.photo_library),
            onPressed: () => _pickAndUpload(false),
          ),
        ],
      ),
      body: BlocConsumer<TaskPhotoCubit, TaskPhotoState>(
        listener: (context, state) {
          if (state is TaskPhotoError) {
            AppAlerts.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TaskPhotoLoading || state is TaskPhotoInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskPhotoLoaded) {
            if (state.photos.isEmpty) {
              return const Center(child: Text('Fotoğraf bulunamadı.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                final widgetImage = photo.base64Image.startsWith('http')
                    ? Image.network(photo.base64Image, fit: BoxFit.cover)
                    : Image.memory(
                        base64Decode(photo.base64Image),
                        fit: BoxFit.cover,
                      );

                return GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (ctx, anim1, anim2) {
                        return Center(
                          child: Material(
                            color: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: photo.base64Image.startsWith('http')
                                  ? Image.network(photo.base64Image, fit: BoxFit.contain)
                                  : Image.memory(base64Decode(photo.base64Image), fit: BoxFit.contain),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (ctx, anim1, anim2, child) {
                        return FadeTransition(
                          opacity: anim1,
                          child: ScaleTransition(
                            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
                            child: child,
                          ),
                        );
                      },
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
                            );
                            if (!ok) return;
                            await context.read<TaskPhotoCubit>().delete(photo.id);
                            AppAlerts.showSuccess(context, 'Fotoğraf silindi.');
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // Başlangıçta boş göster
          return const SizedBox.shrink();
        },
      ),
    );
  }
}