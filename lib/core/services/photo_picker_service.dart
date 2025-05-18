import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Kameradan veya galeriden tek fotoğraf seçer
  static Future<File?> pickImage({required bool fromCamera}) async {
    if (kIsWeb) return null;

    final permissionGranted = fromCamera
        ? await _getCameraPermission()
        : await _getGalleryPermission();

    if (!permissionGranted) return null;

    try {
      final pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 75,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      debugPrint('Fotoğraf seçme hatası: $e');
      return null;
    }
  }

  /// Galeriden birden fazla fotoğraf seçer
  static Future<List<File>> pickMultipleFromGallery() async {
    if (kIsWeb) return [];

    final permissionGranted = await _getGalleryPermission();
    if (!permissionGranted) return [];

    try {
      final pickedFiles = await _picker.pickMultiImage();
      return pickedFiles.map((e) => File(e.path)).toList();
    } catch (e) {
      debugPrint('Çoklu fotoğraf seçme hatası: $e');
      return [];
    }
  }

  /// Galeri izni kontrolü (Android/iOS)
  static Future<bool> _getGalleryPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    } else if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return false;
  }

  /// Kamera izni kontrolü
  static Future<bool> _getCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Android 13 ve üzeri kontrolü
  static Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;
    try {
      final sdkInt = await _getAndroidSdkInt();
      return sdkInt != null && sdkInt >= 33;
    } catch (_) {
      return false;
    }
  }

  /// Android SDK versiyonu al
  static Future<int?> _getAndroidSdkInt() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    } catch (e) {
      debugPrint("Android SDK versiyonu alınamadı: $e");
      return null;
    }
  }
}
