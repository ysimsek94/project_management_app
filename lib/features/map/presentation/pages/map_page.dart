import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/widgets/app_circular_indicator.dart';
import '../../../../core/widgets/app_custom_app_bar.dart';
import '../../../../core/widgets/app_map_selector.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

class TaskMapPage extends StatelessWidget {
  const TaskMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        if (state is MapLoading) {
          return const AppCircularIndicator();
        } else if (state is MapLoaded) {
          // Görev konumlarını çek
          final locations = state.projects
              .map((t) => t.proje.geom?['coordinates'])
              .where((coord) => coord != null && coord is List && coord.length >= 2)
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();

          // Compute map center as average of marker positions
          LatLng? center;
          if (locations.isNotEmpty) {
            final avgLat = locations.map((p) => p.latitude).reduce((a, b) => a + b) / locations.length;
            final avgLng = locations.map((p) => p.longitude).reduce((a, b) => a + b) / locations.length;
            center = LatLng(avgLat, avgLng);
          }
          // For future: customize marker style to circular if MapSelector allows (e.g. via markerBuilder)
          return Scaffold(
            appBar: const CustomAppBar(
              title: "Görev Listesi",
              showBackButton: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MapSelector(
                initialLocation: center,
                initialPoints: locations,
                mode: MapInteractionMode.viewOnly,
                onPointsChanged: (_) {},
                enableSearch: false,
                autoInitLocation: false,
              ),
            ),
          );
        } else if (state is MapError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}