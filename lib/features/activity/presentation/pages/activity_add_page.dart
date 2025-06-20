import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/extensions/date_extensions.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_gorev_model.dart';
import 'package:project_management_app/features/activity/data/models/faliyet_response_model.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/gorev_durum_enum.dart';
import '../../../../core/page/base_page.dart';
import '../../../../core/page/map_interaction_page.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/utils/app_map_utils.dart';
import '../../../../core/widgets/app_alerts.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_date_time_picker.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_map_selector.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../injection.dart';
import '../../../activity_photo/presentation/bloc/activity_photo_cubit.dart';
import '../../../activity_photo/presentation/pages/activity_gallery_page.dart';
import '../bloc/activity_cubit.dart';
import '../bloc/activity_state.dart';

/// Görev ekleme/düzenleme sayfası.
class ActivityAddPage extends StatefulWidget {
  final FaliyetResponseModel? activity;

  const ActivityAddPage({Key? key, this.activity}) : super(key: key);

  @override
  State<ActivityAddPage> createState() => _ActivityAddPageState();
}

/// ActivityAddPage içinde medya eylemlerini tanımlar
enum _MediaAction { gallery, selectLocation, openMap }

class _ActivityAddPageState extends State<ActivityAddPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller tanımları
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _startDateCtrl;
  late TextEditingController _activityCtrl;
  late TextEditingController _completionDateCtrl;

  // Durum seçeneği ve varsayılan zaman/konum
  GorevDurumEnum? _status;
  DateTime? _selectedStartDate;
  DateTime? _selectedCompletionDate;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadActivityData();
  }

  @override
  void dispose() {
    // Controller’ları serbest bırak
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _startDateCtrl.dispose();
    _activityCtrl.dispose();
    _completionDateCtrl.dispose();
    super.dispose();
  }

  /// Controller’ları ilk değerlerle oluşturur
  void _initControllers() {
    _titleCtrl =
        TextEditingController(text: widget.activity?.faliyetGorev.gorev ?? '');
    _descCtrl =
        TextEditingController(text: widget.activity?.faliyetGorev.islem ?? '');
    _activityCtrl =
        TextEditingController(text: widget.activity?.faliyetAdi ?? '');

    if (widget.activity?.faliyetGorev.baslangicTarihi != null) {
      _selectedStartDate =
          DateTime.tryParse(widget.activity!.faliyetGorev.baslangicTarihi!) ??
              _selectedStartDate;
    }
    _startDateCtrl = TextEditingController(text: _selectedStartDate?.dMy);

    if (widget.activity?.faliyetGorev.tamamlanmaTarihi != null) {
      _selectedCompletionDate =
          DateTime.tryParse(widget.activity!.faliyetGorev.tamamlanmaTarihi!) ??
              _selectedCompletionDate;
    }
    _completionDateCtrl =
        TextEditingController(text: _selectedCompletionDate?.dMy);

    // Gelen görev durumu enum olarak al
    final incoming = widget.activity?.faliyetGorev.durum;
    if (incoming != null) {
      _status = incoming;
    }
  }

  /// Varsayılan tarih, saat ve konumu yükler
  void _loadActivityData() {
    if (widget.activity?.faliyetGorev.baslangicTarihi?.isNotEmpty == true) {
      _selectedStartDate =
          DateTime.tryParse(widget.activity!.faliyetGorev.baslangicTarihi!) ??
              _selectedStartDate;
      _startDateCtrl.text = _selectedStartDate!.dMy;
    }
    if (widget.activity?.faliyetGorev.tamamlanmaTarihi?.isNotEmpty == true) {
      _selectedCompletionDate =
          DateTime.tryParse(widget.activity!.faliyetGorev.tamamlanmaTarihi!) ??
              _selectedCompletionDate;
      _completionDateCtrl.text = _selectedCompletionDate!.dMy;
    }
    _selectedLatLng = _parseGeoPoint(widget.activity?.faliyetGorev.geom);
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

    final activity = FaliyetGorevModel(
      islemTarihi: DateTime.now().toIso8601String(),
      kayitEden: AppPreferences.username ?? '',
      id: widget.activity!.faliyetGorev.id,
      faliyetId: widget.activity!.faliyetId,
      islemId: widget.activity!.islemId,
      gorev: widget.activity!.faliyetGorev.gorev ?? '',
      baslangicTarihi: _startDateCtrl.text.toIsoOrEmpty,
      islem: _descCtrl.text.trim(),
      fizikiYuzde: 0.0,
      tamamlanmaTarihi: _completionDateCtrl.text.toIsoOrEmpty,
      durum: _status!,
      geom: _selectedLatLng != null
          ? _generatePointGeometry(_selectedLatLng!)
          : null,
    );

    if (widget.activity == null) {
      //context.read<ActivityCubit>().addActivity(activity);
    } else {
      context.read<ActivityCubit>().updateActivity(activity);
    }
  }

  bool _isActivityValid() {
    return widget.activity != null && widget.activity!.faliyetGorev.id > 0;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.activity == null ? 'Görev Ekle' : 'Görevi Düzenle',
      showBackButton: true,
      child: SafeArea(
        child: BlocConsumer<ActivityCubit, ActivityState>(
          listener: _blocListener,
          builder: (context, state) {
            return _buildForm(state is ActivityOperationInProgress);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _showActionSheet,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.more_vert, size: 20),
      ),
    );
  }

  /// Cubit dinleyici: başarılı ya da hata durumunda işlem yapar
  void _blocListener(BuildContext context, ActivityState state) {
    if (state is ActivityCreateSuccess || state is ActivityUpdateSuccess) {
      final msg =
          widget.activity == null ? 'Görev eklendi.' : 'Görev güncellendi.';
      AppAlerts.showSuccess(context, msg);
    } else if (state is ActivityFailure) {
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
            AppTextField(
              hint: 'Faliyet Adı',
              textEditingController: _activityCtrl,
              readOnly: true,
            ),
            AppSizes.gapH20,
            AppTextField(
              hint: 'Görevi',
              textEditingController: _titleCtrl,
              readOnly: true,
            ),
            AppSizes.gapH20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
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
                ),
                AppSizes.gapW12,
                Expanded(
                  child: _buildTextField(
                    textEditingController: _completionDateCtrl,
                    hint: 'Tamamlanma Tarihi',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz!';
                      }
                      return null;
                    },
                    readOnly: true,
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
                ),
              ],
            ),
            AppSizes.gapH20,
            _buildTextField(
              textEditingController: _descCtrl,
              hint: 'İşlem',
              validatorMsg: 'İşlem açıklaması giriniz',
              maxLines: 3
            ),
            AppSizes.gapH32,
            _buildStatusDropdown(),
            AppSizes.gapH32,
            AppButton(
              title: widget.activity == null ? 'Kaydet' : 'Güncelle',
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
    int maxLines = 1,
  }) {
    return AppTextField(
      hint: hint,
      readOnly: readOnly,
      textEditingController: textEditingController,
      onTap: onTap,
      maxLines: maxLines,
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
      hint: const Text('Lütfen durum seçiniz'),
      items: GorevDurumEnum.values
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.label),
              ))
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
            if (!_isActivityValid()) {
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
    if (!_isActivityValid()) {
      AppAlerts.showError(context, "Lütfen önce görevi kaydedin.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ActivityPhotoCubit>(),
          child:
              ActivityGalleryPage(activityItemRequestModel: widget.activity!),
        ),
      ),
    );
  }

  /// Harita seçici dialog’u açar ve sonucu alır
  Future<void> _openMapSelector() async {
    if (!_isActivityValid()) {
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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Seçenekler',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
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
                      if (!_isActivityValid()) {
                        AppAlerts.showError(
                            context, "Lütfen önce görevi kaydedin.");
                        return;
                      }
                       await Navigator.push<LatLng>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapInteractionPage(
                            title: 'Haritada Konum Seç',
                            mode: MapInteractionMode.selectSingle,
                            initialPoints: _selectedLatLng != null
                                ? [_selectedLatLng!]
                                : [],
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
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
