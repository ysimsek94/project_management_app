import 'package:flutter/material.dart';
import 'package:project_management_app/core/widgets/app_custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/extensions/string_extensions.dart';
import 'package:project_management_app/core/page/gallery_page.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_dropdown.dart';
import 'package:project_management_app/core/widgets/app_dialog.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:project_management_app/features/task/presentation/bloc/task_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/page/map_interaction_page.dart';
import '../../../../core/utils/app_map_utils.dart';
import '../../../../core/widgets/app_date_time_picker.dart';
import '../../../../core/widgets/app_map_selector.dart';
import '../../domain/entities/task.dart';

/// Görev oluşturma veya düzenleme sayfası.
class TaskAddPage extends StatefulWidget {
  final Task? task;

  const TaskAddPage({Key? key, this.task}) : super(key: key);

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _timeCtrl;
  String? _status;
  DateTime _selectedDateTime = DateTime.now();
  LatLng? _selectedLatLng;

  // Ön tanımlı görev durumu seçenekleri.
  static const List<String> _statusOptions = [
    'yapılacak',
    'devam ediyor',
    'tamamlandı',
  ];

  /// Sayfa yüklendiğinde mevcut görev varsa veriler doldurulur.
  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data or empty.
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.status;
    if (widget.task?.dueTime != null) {
      _selectedDateTime =
          DateTime.tryParse(widget.task!.dueTime!) ?? DateTime.now();
    }
    if (widget.task?.latitude != null && widget.task?.longitude != null) {
      _selectedLatLng = LatLng(widget.task!.latitude!, widget.task!.longitude!);
    }
    _dateCtrl = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_selectedDateTime));
    _timeCtrl = TextEditingController(
        text: DateFormat('HH:mm').format(_selectedDateTime));
  }

  @override
  void dispose() {
    // Kontrolleri serbest bırak
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  /// Form doğrulanır ve görev Cubit'e gönderilir (ekle/güncelleme).
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Bloc/Cubit üzerinden gönder.
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
          // Görev başarıyla eklendi/güncellendiğinde ekrana bildirim göster ve geri dön
          listener: (context, state) {
            if (state is TaskCreateSuccess || state is TaskUpdateSuccess) {
              final message =
                  widget.task == null ? 'Görev eklendi.' : 'Görev güncellendi.';
              AppAlerts.showSuccess(context, message);
              Navigator.of(context).pop(true);
            } else if (state is TaskFailure) {
              AppAlerts.showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is TaskOperationInProgress;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Başlık girdi alanı
                      AppTextField(
                        hint: 'Başlık',
                        textEditingController: _titleCtrl,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Lütfen başlık giriniz'
                            : null,
                      ),
                      AppSizes.gapH20,
                      // Açıklama alanı
                      AppTextField(
                        hint: 'Açıklama',
                        textEditingController: _descCtrl,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Lütfen açıklama giriniz'
                            : null,
                      ),
                      AppSizes.gapH32,
                      // Tarih ve Saat seçim alanları
                      Row(
                        children: [
                          Expanded(
                            // Tarih seçimi için input alanı (sadece gösterim, tıklanabilir)
                            child: AppTextField(
                              hint: "Tarih",
                              textEditingController: _dateCtrl,
                              readOnly: true,
                              onTap: () async {
                                final picked = await DateTimePickers.pickDate(
                                    context, _selectedDateTime);
                                if (picked != null) {
                                  setState(() {
                                    _selectedDateTime = picked;
                                    _dateCtrl.text =
                                        DateFormat('dd/MM/yyyy').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                          AppSizes.gapW12,
                          Expanded(
                            // Saat seçimi için input alanı (sadece gösterim, tıklanabilir)
                            child: AppTextField(
                              hint: "Saat",
                              textEditingController: _timeCtrl,
                              readOnly: true,
                              onTap: () async {
                                final picked = await DateTimePickers.pickTime(
                                    context, _selectedDateTime);
                                if (picked != null) {
                                  setState(() {
                                    _selectedDateTime = picked;
                                    _timeCtrl.text =
                                        DateFormat('HH:mm').format(picked);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      AppSizes.gapH32,
                      // Durum seçimi dropdown menü
                      AppDropdown<String>(
                        value: _status,
                        hint: const Text('Durum seçiniz'),
                        items: _statusOptions
                            .map((s) => DropdownMenuItem(
                                value: s, child: Text(s.capitalize())))
                            .toList(),
                        onChanged: (v) => setState(() => _status = v),
                        validator: (v) =>
                            v == null ? 'Lütfen durum seçiniz' : null,
                      ),
                      AppSizes.gapH32,

                      // Galeriye gitmek için buton
                      AppButton(
                        title: 'Galeri',
                        icon: Icons.photo_library_outlined,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GalleryPage(),
                            ),
                          );
                        },
                      ),
                      AppSizes.gapH12,
                      // Harita üzerinde konum seçmek için buton
                      AppButton(
                        title: _selectedLatLng != null
                            ? 'Konum: ${_selectedLatLng!.latitude.toStringAsFixed(4)}, ${_selectedLatLng!.longitude.toStringAsFixed(4)}'
                            : 'Konum Seç',
                        icon: Icons.location_on_outlined,
                        onClick: () async {
                          // Harita üzerinden konum seçimi işlemini başlatır
                          LatLng? tempLatLng = _selectedLatLng;
                          final selected =
                              await AppDialog.showCustomDialog<LatLng>(
                            context: context,
                            title: 'Konum Seç',
                            icon: Icons.map_outlined,
                            content: SizedBox(
                              height: 400,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: MapSelector(
                                mode: MapInteractionMode.selectSingle,
                                initialPoints: _selectedLatLng != null
                                    ? [_selectedLatLng!]
                                    : null,
                                onPointsChanged: (points) {
                                  if (points.isNotEmpty) {
                                    setState(() => tempLatLng = points.first);
                                  }
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
                                  onClick: () =>
                                      Navigator.pop(context, tempLatLng),
                                ),
                              ),
                            ],
                          );
                          if (selected != null) {
                            setState(() => _selectedLatLng = selected);
                          }
                        },
                      ),
                      AppSizes.gapH12,
                      // Harita üzerinde konumu tam ekran açmak için buton
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
                                initialPoints: _selectedLatLng != null
                                    ? [_selectedLatLng!]
                                    : [],
                                onResult: (List<LatLng> result) {
                                  if (result.isNotEmpty) {
                                    setState(
                                        () => _selectedLatLng = result.first);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      if (_selectedLatLng != null) ...[
                        AppSizes.gapH12,
                        // Yol tarifi almak için buton
                        AppButton(
                            title: 'Yol Tarifi Al',
                            icon: Icons.directions,
                            onClick: () =>
                                MapUtils.openInMaps(_selectedLatLng!)),
                      ],
                      AppSizes.gapH32,
                      // Gönder butonu (Kaydet veya Güncelle)
                      AppButton(
                        title: widget.task == null ? 'Kaydet' : 'Güncelle',
                        isLoading: isLoading,
                        onClick: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
