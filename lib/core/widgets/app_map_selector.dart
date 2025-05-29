import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    _points = widget.initialPoints ??
        (widget.initialLocation != null ? [widget.initialLocation!] : []);
    if (widget.autoInitLocation) {
      _handlePermissionsAndInit();
    }
  }

  /// Requests location permission and service, then sets initial point.
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
    LatLng loc;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      loc = LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        loc = LatLng(last.latitude, last.longitude);
      } else {
        loc = LatLng(41.0082, 28.9784); // Istanbul
      }
    }
    setState(() {
      _points = [loc];
    });
    widget.onPointsChanged(_points);
    // Move map center to new location
    _mapController.move(loc, 15.0);
  }

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
      _mapController.move(_points.first, _mapController.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = _points.isNotEmpty ? _points.first : LatLng(41.015137, 28.979530);
    return Column(
      children: [
        if (widget.enableSearch)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<String>(
              // Build the TextField
              builder: (context, TextEditingController controller, FocusNode focusNode) {
                return TextField(
                  controller: _searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Adres ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  borderRadius: BorderRadius.circular(8),
                  child: suggestionsBox,
                );
              },
              // Hide suggestions box when empty
              hideOnEmpty: true,
            ),
          ),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: center,
              zoom: 15.0,
              onTap: (tapPosition, point) => _handleTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.project_management_app',
              ),
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
              MarkerLayer(
                markers: _points.map((point) {
                  return Marker(
                    point: point,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
