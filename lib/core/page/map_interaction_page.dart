import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import '../widgets/app_custom_app_bar.dart';
import '../widgets/app_map_selector.dart';

/// Bu sayfa, kullanıcıya etkileşimli bir harita göstererek belirli bir modda
/// konum (nokta, çoklu nokta veya çizgi) seçmesini sağlar.
/// Seçilen konum(lar), onResult callback'i ile geri döndürülür.
class MapInteractionPage extends StatefulWidget {
  final LatLng? initialLocation;
  final List<LatLng>? initialPoints;
  final String title;
  final Function(List<LatLng>) onResult;
  final MapInteractionMode mode;

  const MapInteractionPage({
    Key? key,
    required this.title,
    required this.onResult,
    required this.mode,
    this.initialLocation,
    this.initialPoints,
  }) : super(key: key);

  @override
  State<MapInteractionPage> createState() => _MapInteractionPageState();
}

class _MapInteractionPageState extends State<MapInteractionPage> {
  late List<LatLng> _points;

  @override
  void initState() {
    super.initState();
    _points = widget.initialPoints ??
        (widget.initialLocation != null ? [widget.initialLocation!] : []);
  }

  /// Harita üzerinde yapılan değişikliklerle birlikte seçilen noktaları günceller.
  void _onPointsChanged(List<LatLng> updated) {
    setState(() {
      _points = updated;
    });
  }

  /// Seçilen konum(ları) üst bileşene döndürür ve sayfayı kapatır.
  void _submit() {
    widget.onResult(_points);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
        onBack: () => Navigator.of(context).pop<LatLng?>(null),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Harita bileşenini içeren genişletilebilir alan
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapSelector(
                  initialLocation: widget.initialLocation,
                  initialPoints: widget.initialPoints,
                  mode: widget.mode,
                  onPointsChanged: _onPointsChanged,
                  enableSearch: true,
                ),
              ),
            ),
            AppSizes.gapH16,
            // Kullanıcı seçimini onaylayarak üst bileşene ileten buton
            AppButton(
              width: double.infinity,
              title: "Konumu Kaydet",
              onClick: _submit,
            ),
            AppSizes.gapH24,
          ],
        ),
      ),
    );
  }
}