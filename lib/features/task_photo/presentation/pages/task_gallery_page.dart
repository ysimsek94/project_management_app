import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/services/photo_picker_service.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/page/base_page.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../task/data/models/task_list_item_model.dart';
import '../../data/models/task_photo_model.dart';
import '../bloc/task_photo_cubit.dart';
import '../bloc/task_photo_state.dart';

class TaskGalleryPage extends StatefulWidget {
  final TaskListItemModel taskItemRequestModel;
  const TaskGalleryPage({Key? key, required this.taskItemRequestModel}) : super(key: key);

  @override
  State<TaskGalleryPage> createState() => _TaskGalleryPageState();
}

class _TaskGalleryPageState extends State<TaskGalleryPage> {
  @override
  void initState() {
    super.initState();
    // Sayfa açılınca fazId, gorevId ve loadImage ile fotoğrafları yükle
    context.read<TaskPhotoCubit>().loadPhotos(
      fazId: widget.taskItemRequestModel.projeFazGorev.fazId,
      gorevId: widget.taskItemRequestModel.projeFazGorev.id,
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
            radius: 28.r,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(icon, size: 28.sp, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(bool fromCamera) async {
    final file = await PhotoPickerService.pickImage(fromCamera: fromCamera,context: context);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    // Derive the file name and extension
    final fileName = p.basename(file.path);
    final fileExtension = p.extension(file.path).replaceFirst('.', '');

    final base64 = base64Encode(bytes);

    try {
      await context.read<TaskPhotoCubit>().upload(
        TaskPhotoModel(
          id:0,
          fazId: widget.taskItemRequestModel.projeFazGorev.fazId,
          gorevId: widget.taskItemRequestModel.projeFazGorev.id,
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
      child: BlocConsumer<TaskPhotoCubit, TaskPhotoState>(
        listener: (context, state) {
          if (state is TaskPhotoError) {
            AppAlerts.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TaskPhotoLoading && state.photos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final photos = (state is TaskPhotoLoaded
              ? state.photos
              : state is TaskPhotoLoading
              ? state.photos
              : <TaskPhotoModel>[]);
          if (state is TaskPhotoLoaded && photos.isEmpty) {
            return const Center(child: Text('Fotoğraf bulunamadı.'));
          }
          return Stack(
            children: [
              if (photos.isNotEmpty)
                GridView.builder(
                  padding: EdgeInsets.all(12.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
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
                                  top: 16.h,
                                  right: 16.w,
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(8.w),
                                      child: Icon(Icons.close, color: Colors.white, size: 24.sp),
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
                              padding: EdgeInsets.all(4.w),
                              constraints: const BoxConstraints(),
                              iconSize: 16.sp,
                              color: Colors.white,
                              icon: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.delete, size: 24.sp, color: Colors.white),
                              ),
                              onPressed: () async {
                                final ok = await AppAlerts.showConfirmationDialog(
                                  context,
                                  title: 'Silmek istiyor musunuz?',
                                  confirmText: "Sil",
                                  cancelText: "Kapat",
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
                ),
              if (state is TaskPhotoLoading)
                Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _showActionSheet,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Fotoğraf Ekle',
        child: const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Seçenekler',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionCard(
                    Icons.photo_library_outlined,
                    'Galeri',
                        () {
                      Navigator.pop(context);
                      _pickAndUpload(false);
                    },
                  ),
                  _buildActionCard(
                    Icons.camera_alt,
                    'Kamera',
                        () {
                      Navigator.pop(context);
                      _pickAndUpload(true);
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

}