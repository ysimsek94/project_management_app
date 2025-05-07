import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  const MapSelector({
    Key? key,
    this.initialLocation,
    this.initialPoints,
    required this.mode,
    required this.onPointsChanged,
  }) : super(key: key);

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  late List<LatLng> _points;

  @override
  void initState() {
    super.initState();
    _points = widget.initialPoints ??
        (widget.initialLocation != null ? [widget.initialLocation!] : []);
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
  }

  @override
  Widget build(BuildContext context) {
    final center = _points.isNotEmpty ? _points.first : LatLng(41.015137, 28.979530);
    return FlutterMap(
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
    );
  }
}
