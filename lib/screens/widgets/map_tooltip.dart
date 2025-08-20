import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWithTooltip extends StatefulWidget {
  final LatLng coords;
  final String attractionName;
  final String mapImageUrl;
  final Color primary;
  final Color icons;
  final void Function(String url) onTap;

  const MapWithTooltip({
    super.key,
    required this.coords,
    required this.attractionName,
    required this.mapImageUrl,
    required this.primary,
    required this.icons,
    required this.onTap,
  });

  @override
  State<MapWithTooltip> createState() => _MapWithTooltipState();
}

class _MapWithTooltipState extends State<MapWithTooltip> with SingleTickerProviderStateMixin {
  bool _showTooltip = true;
  double _tooltipOpacity = 1.0;
  Timer? _tooltipTimer;

  @override
  void initState() {
    super.initState();

    //fades out after 4 seconds
    _tooltipTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _tooltipOpacity = 0.0;
        });
      }

      //remove the widget after the fade duration
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _showTooltip = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _tooltipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.hardEdge,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: widget.coords,
              initialZoom: 15,
              onTap: (tapPosition, latLng) {
                widget.onTap(widget.mapImageUrl);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.coords,
                    width: 160,
                    height: 80,
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.icons,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.attractionName,
                            style: TextStyle(
                              color: widget.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (_showTooltip)
  Positioned(
    bottom: 12,
    left: 12,
    child: AnimatedOpacity(
      opacity: _tooltipOpacity,
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.touch_app, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              'Tap map to open',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
  ),

      ],
    );
  }
}
