import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
import 'package:project_management_app/core/widgets/app_dialog.dart';
import 'package:project_management_app/core/widgets/app_dropdown.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_map_selector.dart';
import 'package:project_management_app/core/utils/app_map_utils.dart';
import 'package:project_management_app/features/task/data/models/task_request_model.dart';
import 'package:project_management_app/features/task/data/models/task_list_item_model.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_state.dart';
import '../../../../core/constants/gorev_durum_enum.dart';
import '../../../../core/page/base_page.dart';
import '../../../../core/page/map_interaction_page.dart';
import '../../../../core/widgets/app_date_time_picker.dart';
import '../../../../injection.dart';
import '../../../task_photo/presentation/bloc/task_photo_cubit.dart';
import '../../../task_photo/presentation/pages/task_gallery_page.dart';

/// Görev ekleme/düzenleme sayfası.
class TaskAddPage extends StatefulWidget {
  final TaskListItemModel? task;

  const TaskAddPage({Key? key, this.task}) : super(key: key);

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}
/// TaskAddPage içinde medya eylemlerini tanımlar
enum _MediaAction { gallery, selectLocation, openMap }
class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller tanımları
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _startDateCtrl;
  late TextEditingController _projectCtrl;
  late TextEditingController _phaseCtrl;
  late TextEditingController _completionDateCtrl;

  DateTime? _selectedStartDate;
  DateTime? _selectedCompletionDate;
  LatLng? _selectedLatLng;
  GorevDurumEnum? _status;


  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadTaskData();
  }

  @override
  void dispose() {
    // Controller’ları serbest bırak
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _startDateCtrl.dispose();
    _projectCtrl.dispose();
    _phaseCtrl.dispose();
    _completionDateCtrl.dispose();
    super.dispose();
  }

  /// Controller’ları ilk değerlerle oluşturur
  void _initControllers() {
    _titleCtrl =
        TextEditingController(text: widget.task?.projeFazGorev.gorev ?? '');
    _descCtrl =
        TextEditingController(text: widget.task?.projeFazGorev.islem ?? '');
    _projectCtrl = TextEditingController(text: widget.task?.projeAdi ?? '');
    _phaseCtrl = TextEditingController(text: widget.task?.fazAdi ?? '');

    if (widget.task?.projeFazGorev.baslangicTarihi != null) {
      _selectedStartDate =
          DateTime.tryParse(widget.task!.projeFazGorev.baslangicTarihi!) ??
              _selectedStartDate;
    }
    _startDateCtrl = TextEditingController(text: _selectedStartDate?.dMy);

    if (widget.task?.projeFazGorev.tamamlanmaTarihi != null) {
      _selectedCompletionDate =
          DateTime.tryParse(widget.task!.projeFazGorev.tamamlanmaTarihi!) ??
              _selectedCompletionDate;
    }
    _completionDateCtrl =
        TextEditingController(text: _selectedCompletionDate?.dMy);

    // Gelen görev durumu doğrudan ata
    final incoming = widget.task?.projeFazGorev.durum;
    if (incoming != null) {
      _status = incoming;
    }


  }

  /// Varsayılan tarih, saat ve konumu yükler
  void _loadTaskData() {
    if (widget.task?.projeFazGorev.baslangicTarihi?.isNotEmpty == true) {
      _selectedStartDate =
          DateTime.tryParse(widget.task!.projeFazGorev.baslangicTarihi!) ??
              _selectedStartDate;
      _startDateCtrl.text = _selectedStartDate!.dMy;
    }
    if (widget.task?.projeFazGorev.tamamlanmaTarihi?.isNotEmpty == true) {
      _selectedCompletionDate =
          DateTime.tryParse(widget.task!.projeFazGorev.tamamlanmaTarihi!) ??
              _selectedCompletionDate;
      _completionDateCtrl.text = _selectedCompletionDate!.dMy;
    }
    _selectedLatLng = _parseGeoPoint(widget.task?.projeFazGorev.geom);

  }
  /// GeoJSON içinden LatLng nesnesi döner, yoksa null verir
  LatLng? _parseGeoPoint(Map<String, dynamic>? geom) {
    final coords = (geom?['coordinates'] as List?)?.cast<num>();
    if (coords != null && coords.length >= 2) {
      return LatLng(coords[1].toDouble(), coords[0].toDouble());
    }
    return null;
  }

  /// Form geçerliyse Cubit’e ekle/güncelle gönderir
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_status == null) {
      AppAlerts.showError(context, "Lütfen görev durumu seçiniz.");
      return;
    }

    final task = TaskRequestModel(
      islemTarihi: DateTime.now().toIso8601String(),
      kayitEden: AppPreferences.username ?? '',
      id: widget.task!.projeFazGorev.id,
      fazId: widget.task!.projeFazGorev.fazId,
      gorev: widget.task!.projeFazGorev.gorev ?? '',
      baslangicTarihi: _startDateCtrl.text.toIsoOrEmpty,
      islem: _descCtrl.text.trim(),
      nakdiYuzde: 0.0,
      fizikiYuzde: 0.0,
      gerceklesmeYuzde: 0.0,
      tamamlanmaTarihi: _completionDateCtrl.text.toIsoOrEmpty,
      durum: _status!,
      geom: _selectedLatLng != null
          ? _generatePointGeometry(_selectedLatLng!)
          : null,
    );

    if (widget.task == null) {
      //context.read<TaskCubit>().addTask(task);
    } else {
      context.read<TaskCubit>().updateTask(task);
    }
  }

  bool _isTaskValid() {
    return widget.task != null && widget.task!.projeFazGorev.id > 0;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.task == null ? 'Görev Ekle' : 'Görevi Düzenle',
      showBackButton: true,
      child:SafeArea(
            child: BlocConsumer<TaskCubit, TaskState>(
              listener: _blocListener,
              builder: (context, state) {
                return _buildForm(state is TaskOperationInProgress);
              },
            ),
          ),
        floatingActionButton:   FloatingActionButton.small(
            onPressed: _showActionSheet,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            child: const Icon(Icons.more_vert, size: 20),
          ),
    );
  }

  /// Cubit dinleyici: başarılı ya da hata durumunda işlem yapar
  void _blocListener(BuildContext context, TaskState state) {
    if (state is TaskCreateSuccess || state is TaskUpdateSuccess) {
      final msg = widget.task == null ? 'Görev eklendi.' : 'Görev güncellendi.';
      AppAlerts.showSuccess(context, msg);
    } else if (state is TaskFailure) {
      AppAlerts.showError(context, state.message);
    }
  }

  /// Ana form widget’ı
  Widget _buildForm(bool isLoading) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Proje Adı
            Text('Proje Adı', style: labelStyle),
            SizedBox(height: 4.h),
            AppTextField(
              hint: 'Proje Adı',
              textEditingController: _projectCtrl,
              readOnly: true,
            ),
            SizedBox(height: 16.h),
            // Faz Adı
            Text('Faz Adı', style: labelStyle),
            SizedBox(height: 4.h),
            AppTextField(
              hint: 'Faz Adı',
              textEditingController: _phaseCtrl,
              readOnly: true,
            ),
            SizedBox(height: 16.h),
            // Görev
            Text('Görev', style: labelStyle),
            SizedBox(height: 4.h),
            AppTextField(
              hint: 'Görevi',
              textEditingController: _titleCtrl,
              readOnly: true,
            ),
            SizedBox(height: 16.h),
            // Başlangıç Tarihi ve Tamamlanma Tarihi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Başlangıç Tarihi', style: labelStyle),
                      SizedBox(height: 4.h),
                      _buildTextField(
                        textEditingController: _startDateCtrl,
                        hint: 'Başlangıç Tarihi',
                        readOnly: true,
                        onTap: () async {
                          // final picked = await DateTimePickers.pickDate(
                          //   context, _selectedStartDate ?? DateTime.now(),
                          // );
                          // if (picked != null) {
                          //   setState(() {
                          //     _selectedStartDate = picked;
                          //     _startDateCtrl.text = picked.dMy;
                          //   });
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tamamlanma Tarihi', style: labelStyle),
                      SizedBox(height: 4.h),
                      _buildTextField(
                        textEditingController: _completionDateCtrl,
                        hint: 'Tamamlanma Tarihi',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Tarih Seçiniz!';
                          }
                          return null;
                        },
                        onTap: () async {
                          final picked = await DateTimePickers.pickDate(
                            context,
                            _selectedCompletionDate ?? DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedCompletionDate = picked;
                              _completionDateCtrl.text = picked.dMy;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // İşlem Açıklaması
            Text('İşlem Açıklaması', style: labelStyle),
            SizedBox(height: 4.h),
            _buildTextField(
              textEditingController: _descCtrl,
              hint: 'İşlem',
              validatorMsg: 'İşlem açıklaması giriniz',
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            // Durum Dropdown
            Text('Durum', style: labelStyle),
            SizedBox(height: 4.h),
            _buildStatusDropdown(),
            SizedBox(height: 32.h),
            AppButton(
              title: widget.task == null ? 'Kaydet' : 'Güncelle',
              isLoading: isLoading,
              onClick: _submit,
            ),
          ],
        ),
      ),
    );
  }

  /// Başlık veya açıklama için AppTextField oluşturur
  Widget _buildTextField({
    required TextEditingController textEditingController,
    required String hint,
    VoidCallback? onTap,
    String? validatorMsg,
    bool readOnly = false,
    FormFieldValidator<String>? validator,
    int? maxLines,
  }) {
    return AppTextField(
      hint: hint,
      readOnly: readOnly,
      textEditingController: textEditingController,
      onTap: onTap,
      maxLines: maxLines ?? 1,
      validator: validator ??
          (validatorMsg != null
              ? (val) => val == null || val.trim().isEmpty ? validatorMsg : null
              : null),
    );
  }

  /// Durum seçimi için dropdown alanı
  Widget _buildStatusDropdown() {
    return AppDropdown<GorevDurumEnum>(
      value: _status,
      hint: const Text('Görev Durumu'),
      items: GorevDurumEnum.values
          .where((e) => e != GorevDurumEnum.none)
          .map(
            (e) => DropdownMenuItem<GorevDurumEnum>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _status = value),
      validator: (value) => value == null ? 'Lütfen durum seçiniz' : null,
      borderRadius: 8.0,
    );
  }

  /// Galeri ve harita butonlarını bir arada gösterir
  Widget _buildMediaButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          title: 'Galeri',
          icon: Icons.photo_library_outlined,
          onClick: _openGalleryPage,
        ),
        AppSizes.gapH12,
        AppButton(
          title: _selectedLatLng != null
              ? 'Konum: ${_selectedLatLng!.latitude.toStringAsFixed(4)}, ${_selectedLatLng!.longitude.toStringAsFixed(4)}'
              : 'Konum Seç',
          icon: Icons.location_on_outlined,
          onClick: _openMapSelector,
        ),
        AppSizes.gapH12,
        AppButton(
          title: 'Konumu Haritada Aç',
          icon: Icons.fullscreen,
          onClick: () async {
            if (!_isTaskValid()) {
              AppAlerts.showError(context, "Lütfen önce görevi kaydedin.");
              return;
            }
             Navigator.push<LatLng>(
              context,
              MaterialPageRoute(
                builder: (_) => MapInteractionPage(
                  title: 'Haritada Konum Seç',
                  mode: MapInteractionMode.selectSingle,
                  initialPoints:
                      _selectedLatLng != null ? [_selectedLatLng!] : [],
                  onResult: (List<LatLng> result) {
                    if (result.isNotEmpty) {
                      setState(() => _selectedLatLng = result.first);
                    }
                  },
                ),
              ),
            );
          },
        ),
        if (_selectedLatLng != null) ...[
          AppSizes.gapH12,
          AppButton(
            title: 'Yol Tarifi Al',
            icon: Icons.directions,
            onClick: () => MapUtils.openInMaps(_selectedLatLng!),
          ),
        ],
      ],
    );
  }

  /// Galeri sayfasını açar
  Future<void> _openGalleryPage() async {
    if (!_isTaskValid()) {
      AppAlerts.showError(context, "Lütfen önce görevi kaydedin.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<TaskPhotoCubit>(),
          child: TaskGalleryPage(taskItemRequestModel: widget.task!),
        ),
      ),
    );
  }

  /// Harita seçici dialog’u açar ve sonucu alır
  Future<void> _openMapSelector() async {
    if (!_isTaskValid()) {
      AppAlerts.showError(context, "Lütfen önce görevi kaydedin.");
      return;
    }

    // Başlangıç noktası: mevcut seçilmiş lokasyon veya cihazın konumu
    LatLng initialPoint;
    if (_selectedLatLng != null) {
      initialPoint = _selectedLatLng!;
    } else {
      // cihazın güncel konumunu al
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        initialPoint = LatLng(position.latitude, position.longitude);
      } catch (_) {
        // konum alınamazsa varsayılan nokta
        initialPoint = LatLng(0, 0);
      }
    }

    LatLng tempPoint = initialPoint;
    final result = await AppDialog.showCustomDialog<LatLng>(
      context: context,
      title: 'Konum Seç',
      icon: Icons.map_outlined,
      content: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.85,
        child: MapSelector(
          mode: MapInteractionMode.selectSingle,
          initialPoints: [initialPoint],
          onPointsChanged: (pts) {
            if (pts.isNotEmpty) tempPoint = pts.first;
          },
        ),
      ),
      actions: [
        Expanded(
          child: AppButton(
            title: 'İptal',
            type: ButtonType.outlined,
            onClick: () => Navigator.pop(context),
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: AppButton(
            title: 'Kaydet',
            onClick: () => Navigator.pop(context, tempPoint),
          ),
        ),
      ],
    );

    if (result != null) {
      setState(() => _selectedLatLng = result);
    }
  }

  /// GeoJSON Point oluşturur
  Map<String, dynamic> _generatePointGeometry(LatLng point) {
    return <String, dynamic>{
      'type': 'Point',
      'coordinates': <double>[point.longitude, point.latitude],
    };
  }
  /// Builds a circular icon + label card for the action sheet
  Widget _buildActionCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
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

  /// Modern card-style bottom sheet for floating button actions
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
                      _openGalleryPage();
                    },
                  ),
                  // _buildActionCard(
                  //   Icons.location_on_outlined,
                  //   'Konum Seç',
                  //   () {
                  //     Navigator.pop(context);
                  //     _openMapSelector();
                  //   },
                  // ),
                  _buildActionCard(
                    Icons.fullscreen_outlined,
                    'Haritada Aç',
                    () async {
                      Navigator.pop(context);
                      if (!_isTaskValid()) {
                        AppAlerts.showError(context, "Lütfen önce görevi kaydedin.");
                        return;
                      }
                      final result = await Navigator.push<LatLng>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapInteractionPage(
                            title: 'Haritada Konum Seç',
                            mode: MapInteractionMode.selectSingle,
                            initialPoints:
                                _selectedLatLng != null ? [_selectedLatLng!] : [],
                            onResult: (res) {
                              if (res.isNotEmpty) {
                                setState(() => _selectedLatLng = res.first);
                              }
                            },
                          ),
                        ),
                      );
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

