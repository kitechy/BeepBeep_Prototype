import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MarkerService {
  BitmapDescriptor? _jeepneyIcon;

  Future<void> initialize() async {
    _jeepneyIcon ??= await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(64, 64)),
      "assets/icons/jeepney_icon.png",
    );
  }

  // creates a marker from a url
  Future<BitmapDescriptor> getMarkerFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    final codec = await ui.instantiateImageCodec(
      response.bodyBytes,
      targetWidth: 200,
      targetHeight: 200,
    );

    final frame = await codec.getNextFrame();
    final image = frame.image;

    const double size = 60;
    const double border = 5;
    const double pointerHeight = 14;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final center = Offset(size / 2, size / 2);

    final whitePaint = Paint()
      ..color = Colors.white
      ..isAntiAlias = true;

    final bluePaint = Paint()
      ..color = const Color(0xff0000FF)
      ..isAntiAlias = true;

    // Outer blue circle
    canvas.drawCircle(center, size / 2, bluePaint);

    // Inner white circle
    canvas.drawCircle(center, size / 2.5, whitePaint);

    final imageRadius = size / 2 - border;

    canvas.save();

    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: imageRadius)),
    );

    final srcSize = image.width < image.height
        ? image.width.toDouble()
        : image.height.toDouble();

    final srcRect = Rect.fromLTWH(
      (image.width - srcSize) / 2,
      (image.height - srcSize) / 2,
      srcSize,
      srcSize,
    );

    final dstRect = Rect.fromCircle(center: center, radius: imageRadius);

    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );

    canvas.restore();

    // Bottom pointer
    final pointer = Path()
      ..moveTo(size / 2 - 12, size - 4)
      ..lineTo(size / 2 + 12, size - 4)
      ..lineTo(size / 2, size + pointerHeight)
      ..close();

    canvas.drawPath(pointer, bluePaint);

    final picture = recorder.endRecording();

    final img = await picture.toImage(
      size.toInt(),
      (size + pointerHeight).toInt(),
    );

    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  // creates a marker from a url
  Future<Marker> buildMarker({
    required String id,
    required LatLng position,
    String? photoUrl,
    String? title,
    Offset anchor = const Offset(0.5, 0.5),
  }) async {
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      try {
        icon = await getMarkerFromUrl(photoUrl);
      } catch (_) {
        icon = BitmapDescriptor.defaultMarker;
      }
    }

    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: icon,
      anchor: anchor,
      infoWindow: InfoWindow(title: title),
    );
  }

  // 
  Future<Marker> buildJeepneyMarker({
    required String id,
    required LatLng position,
    String? title,
    double rotation = 0,
    VoidCallback? onTap,
  }) async {
    await initialize();

    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: _jeepneyIcon!,
      rotation: rotation,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      onTap: onTap
    );
  }
}
