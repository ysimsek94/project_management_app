import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_alerts.dart';

enum MapInteractionMode {
  viewOnly,
  selectSingle,
  selectMultiple,
  drawPolyline,
}

class MapSelector extends StatefulWidget {
  final LatLng? initialLocation;
  final List<LatLng>? initialPoints;
  final MapInteractionMode mode;
  final Function(List<LatLng>) onPointsChanged;
  final bool autoInitLocation;
  final bool enableSearch;

  const MapSelector({
    Key? key,
    this.initialLocation,
    this.initialPoints,
    required this.mode,
    required this.onPointsChanged,
      this.autoInitLocation = true,
    this.enableSearch = false,
  }) : super(key: key);

  // When true, the widget will request permissions and fetch device location automatically.

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  final MapController _mapController = MapController();
  late List<LatLng> _points;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    /// Arama denetleyicisini, mevcut noktaları ve otomatik konum almayı başlatır.
    /// Eğer başlangıç noktaları varsa üst bileşene bildirir; yoksa cihaz konumunu ister.
    _points = widget.initialPoints ??
        (widget.initialLocation != null ? [widget.initialLocation!] : []);

    if (_points.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onPointsChanged(_points);
      });
    } else if (widget.autoInitLocation) {
      _handlePermissionsAndInit();
    }
  }

  /// Konum servisini ve izinlerini kontrol eder, cihazın güncel konumunu alır,
  /// `_points` listesini günceller, üst bileşeni bilgilendirir ve haritayı merkezler.
  Future<void> _handlePermissionsAndInit() async {
    // Service check
    if (!await Geolocator.isLocationServiceEnabled()) {
      AppAlerts.showError(context, 'Konum servisi kapalı. Lütfen etkinleştirin.');
      return;
    }
    // Permission check
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        AppAlerts.showError(context, 'Konum izni reddedildi.');
        return;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      AppAlerts.showError(context, 'Konum izni kalıcı olarak kapalı. Ayarlardan açın.');
      return;
    }
    // Fetch position
    LatLng? loc;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      loc = LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('Konum alınamadı: $e');
      AppAlerts.showError(context, 'Konum alınamadı. Lütfen konum izinlerini kontrol edin.');
      return;
    }
    if (loc != null) {
      setState(() {
        _points = [loc!];
      });
      widget.onPointsChanged(_points);
      // Move map center to new location
      _mapController.move(loc, 15.0);
    }
  }

  /// Verilen adresi geokodlar, `_points` listesini günceller, üst bileşeni bilgilendirir
  /// ve haritayı bulunan konuma merkezler.
  Future<void> _searchAndCenter(String address) async {
    try {
      final results = await geocoding.locationFromAddress(address);
      if (results.isNotEmpty) {
        final loc = LatLng(results.first.latitude, results.first.longitude);
        setState(() {
          _points = [loc];
        });
        widget.onPointsChanged(_points);
        _mapController.move(loc, 15.0);
      } else {
        AppAlerts.showError(context, 'Adres bulunamadı');
      }
    } catch (e) {
      // Log the error for debugging
      debugPrint('Geocoding error: $e');
      AppAlerts.showError(context, 'Arama sırasında bir hata oluştu. Lütfen kontrol edip tekrar deneyin.');
    }
  }

  /// OpenStreetMap Nominatim API'den adres önerileri alır.
  Future<List<String>> _getAddressSuggestions(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&addressdetails=1&limit=5&q=$query'
    );
    final res = await http.get(url, headers: {'User-Agent': 'FlutterApp'});
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((item) => item['display_name'] as String).toList();
    } else {
      return [];
    }
  }

  /// Harita tıklama olaylarını işler: moda göre noktaları ekler veya değiştirir,
  /// üst bileşeni bilgilendirir ve harita odağını günceller.
  void _handleTap(LatLng point) {
    setState(() {
      switch (widget.mode) {
        case MapInteractionMode.viewOnly:
          // Do nothing
          break;
        case MapInteractionMode.selectSingle:
          _points = [point];
          break;
        case MapInteractionMode.selectMultiple:
        case MapInteractionMode.drawPolyline:
          _points.add(point);
          break;
      }
    });

    widget.onPointsChanged(_points);
    if (_points.isNotEmpty) {
      final focusPoint = (widget.mode == MapInteractionMode.selectMultiple || widget.mode == MapInteractionMode.drawPolyline)
          ? _points.last
          : _points.first;
      _mapController.move(focusPoint, _mapController.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Arama etkinleştirilmişse, önerili bir adres arama girişi gösterir.
    return Column(
      children: [
        if (widget.enableSearch)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.w ,horizontal: 1.w),
            child: TypeAheadField<String>(
              // Build the TextField
              builder: (context, TextEditingController controller, FocusNode focusNode) {
                return TextField(
                  controller: _searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Adres ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => _searchAndCenter(value),
                );
              },
              // Fetch suggestions
              suggestionsCallback: (pattern) async => await _getAddressSuggestions(pattern),
              // Render each suggestion
              itemBuilder: (context, String suggestion) => ListTile(title: Text(suggestion)),
              // Handle selection
              onSelected: (String suggestion) {
                _searchController.text = suggestion;
                _searchAndCenter(suggestion);
              },
              // While loading suggestions
              loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
              // When no suggestions found
              emptyBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Hiçbir öneri bulunamadı.'),
              ),
              // Style the suggestions box
              decorationBuilder: (context, suggestionsBox) {
                return Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8.r),
                  child: suggestionsBox,
                );
              },
              // Hide suggestions box when empty
              hideOnEmpty: true,
            ),
          ),
        // Ana harita kapsayıcısı: OpenStreetMap katmanlarını gösterir ve kullanıcı etkileşimini yönetir.
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            // Eğer `_points` listesi boş değilse, haritayı seçilen noktalara sığdır
            options: _points.isNotEmpty
                ? MapOptions(
                    bounds: LatLngBounds.fromPoints(_points),
                    boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(32)),
                    onTap: (tapPosition, point) => _handleTap(point),
                  )
                // Aksi takdirde, ön tanımlı `initialLocation` ve sabit bir zoom seviyesi kullan
                : MapOptions(
                    center: widget.initialLocation ?? LatLng(0, 0),
                    zoom: 13.0,
                    onTap: (tapPosition, point) => _handleTap(point),
                  ),
            children: [
              // OpenStreetMap karolarını (tiles) kullanan temel harita katmanı.
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.project_management_app',
              ),
              // drawPolyline modu etkinse noktalar arasında çizgi (polyline) çizer.
              if (_points.isNotEmpty &&
                  widget.mode == MapInteractionMode.drawPolyline)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _points,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    )
                  ],
                ),
              // Seçilen her nokta için işaretçi (marker) renderlar.
              MarkerLayer(
                markers: _points.map((point) {
                  return Marker(
                    point: point,
                    width: 40.w,
                    height: 40.w,
                    child: Icon(
                      Icons.place,
                      color: Theme.of(context).primaryColor,
                      size: 36.sp,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }
}
