import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/core/extensions/string_extensions.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
import 'package:project_management_app/core/widgets/app_custom_app_bar.dart';
import 'package:project_management_app/core/widgets/app_dialog.dart';
import 'package:project_management_app/core/widgets/app_dropdown.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_date_time_picker.dart';
import 'package:project_management_app/core/widgets/app_map_selector.dart';
import 'package:project_management_app/core/utils/app_map_utils.dart';
import 'package:project_management_app/features/task/domain/entities/task.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_state.dart';
import 'package:project_management_app/features/task/presentation/pages/task_list_page.dart';

import '../../../../core/page/gallery_page.dart';
import '../../../../core/page/map_interaction_page.dart';

/// Görev ekleme/düzenleme sayfası.
class TaskAddPage extends StatefulWidget {
  final Task? task;

  const TaskAddPage({Key? key, this.task}) : super(key: key);

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller tanımları
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _timeCtrl;

  // Durum seçeneği ve varsayılan zaman/konum
  String? _status;
  DateTime _selectedDateTime = DateTime.now();
  LatLng? _selectedLatLng;

  // Mevcut görev durumu seçenekleri
  static const List<String> _statusOptions = [
    'yapılacak',
    'devam ediyor',
    'tamamlandı',
  ];

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
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  /// Controller’ları ilk değerlerle oluşturur
  void _initControllers() {
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _dateCtrl = TextEditingController(text: _selectedDateTime.yMd,);
    _timeCtrl = TextEditingController(text: _selectedDateTime.hm);
    _status = widget.task?.status;
  }

  /// Varsayılan tarih, saat ve konumu yükler
  void _loadTaskData() {
    if (widget.task?.dueTime != null) {
      _selectedDateTime =
          DateTime.tryParse(widget.task!.dueTime!) ?? _selectedDateTime;
    }
    if (widget.task?.latitude != null && widget.task?.longitude != null) {
      _selectedLatLng = LatLng(widget.task!.latitude!, widget.task!.longitude!);
    }
    // Controller metinlerini güncelle
    _dateCtrl.text = _selectedDateTime.yMd;
    _timeCtrl.text = _selectedDateTime.hm;
  }

  /// Form geçerliyse Cubit’e ekle/güncelle gönderir
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      status: _status!,
      dueTime: _selectedDateTime.toIso8601String(),
      latitude: _selectedLatLng?.latitude,
      longitude: _selectedLatLng?.longitude,
    );
    if (widget.task == null) {
      context.read<TaskCubit>().addTask(task);
    } else {
      context.read<TaskCubit>().updateTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.task == null ? 'Görev Ekle' : 'Görevi Düzenle',
        showBackButton: true,
      ),
      body: SafeArea(
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: _blocListener,
          builder: (context, state) {
            return _buildForm(state is TaskOperationInProgress);
          },
        ),
      ),
    );
  }

  /// Cubit dinleyici: başarılı ya da hata durumunda işlem yapar
  void _blocListener(BuildContext context, TaskState state) {
    if (state is TaskCreateSuccess || state is TaskUpdateSuccess) {
      final msg = widget.task == null ? 'Görev eklendi.' : 'Görev güncellendi.';
      AppAlerts.showSuccess(context, msg);
      Navigator.of(context).pop(true);
    } else if (state is TaskFailure) {
      AppAlerts.showError(context, state.message);
    }
  }

  /// Ana form widget’ı
  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_titleCtrl, 'Başlık', 'Lütfen başlık giriniz'),
            AppSizes.gapH20,
            _buildTextField(_descCtrl, 'Açıklama', 'Lütfen açıklama giriniz'),
            AppSizes.gapH32,
            _buildDateTimePickers(),
            AppSizes.gapH32,
            _buildStatusDropdown(),
            AppSizes.gapH32,
            _buildMediaButtons(),
            AppSizes.gapH32,
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
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    String validatorMsg,
  ) {
    return AppTextField(
      hint: hint,
      textEditingController: controller,
      validator: (val) => val == null || val.isEmpty ? validatorMsg : null,
    );
  }

  /// Tarih ve saat seçici satırı
  Widget _buildDateTimePickers() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            hint: 'Tarih',
            textEditingController: _dateCtrl,
            readOnly: true,
            onTap: () async {
              final picked =
                  await DateTimePickers.pickDate(context, _selectedDateTime);
              if (picked != null) {
                setState(() {
                  _selectedDateTime = picked;
                  _dateCtrl.text = picked.yMd;
                });
              }
            },
          ),
        ),
        AppSizes.gapW12,
        Expanded(
          child: AppTextField(
            hint: 'Saat',
            textEditingController: _timeCtrl,
            readOnly: true,
            onTap: () async {
              final picked =
                  await DateTimePickers.pickTime(context, _selectedDateTime);
              if (picked != null) {
                setState(() {
                  _selectedDateTime = picked;
                  _timeCtrl.text = picked.hm;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  /// Durum seçimi için dropdown alanı
  Widget _buildStatusDropdown() {
    return AppDropdown<String>(
      value: _status,
      hint: const Text('Durum seçiniz'),
      items: _statusOptions
          .map((s) => DropdownMenuItem(value: s, child: Text(s.capitalize())))
          .toList(),
      onChanged: (v) => setState(() => _status = v),
      validator: (v) => v == null ? 'Lütfen durum seçiniz' : null,
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
          onClick: _openGallery,
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
            // Harita sayfasına geçiş ve konum seçimi
            await Navigator.push<LatLng>(
              context,
              MaterialPageRoute(
                builder: (_) => MapInteractionPage(
                  title: 'Haritada Konum Seç',
                  mode: MapInteractionMode.selectSingle,
                  initialPoints: _selectedLatLng != null ? [_selectedLatLng!] : [],
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
  Future<void> _openGallery() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GalleryPage()),
    );
  }

  /// Harita seçici dialog’u açar ve sonucu alır
  Future<void> _openMapSelector() async {
    LatLng? temp = _selectedLatLng;
    final result = await AppDialog.showCustomDialog<LatLng>(
      context: context,
      title: 'Konum Seç',
      icon: Icons.map_outlined,
      content: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.85,
        child: MapSelector(
          mode: MapInteractionMode.selectSingle,
          initialPoints: temp != null ? [temp] : null,
          onPointsChanged: (pts) {
            if (pts.isNotEmpty) temp = pts.first;
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
            onClick: () => Navigator.pop(context, temp),
          ),
        ),
      ],
    );
    if (result != null) {
      setState(() => _selectedLatLng = result);
    }
  }
}
