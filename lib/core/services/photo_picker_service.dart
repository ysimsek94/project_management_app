import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/app_alerts.dart';

class PhotoPickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Kameradan veya galeriden tek fotoğraf seçer
  static Future<File?> pickImage({required bool fromCamera, required BuildContext context}) async {
    if (kIsWeb) return null;

    final permissionGranted = fromCamera
        ? await _getCameraPermission(context)
        : await _getGalleryPermission(context);

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
  static Future<List<File>> pickMultipleFromGallery({required BuildContext context}) async {
    if (kIsWeb) return [];

    AppAlerts.showWarning(context, 'Galeri izni isteniyor...');

    final permissionGranted = await _getGalleryPermission(context);
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
  static Future<bool> _getGalleryPermission(BuildContext context) async {
    // Determine correct permission based on platform and Android version
    final permission = Platform.isIOS
        ? Permission.photos
        : (await _isAndroid13OrAbove() ? Permission.photos : Permission.storage);

    // Request the permission
    final status = await permission.request();

    // Temporarily denied: log and return
    if (status.isDenied) {
      AppAlerts.showWarning(context, 'Galeri izni geçici olarak reddedildi.');
      return false;
    }

    // Permanently denied: log, open app settings, and return
    if (status.isPermanentlyDenied) {
      AppAlerts.showWarning(context, 'Galeri izni kalıcı olarak reddedildi. Ayarlar açılıyor...');
      await openAppSettings();
      return false;
    }

    // Granted or limited (iOS): proceed
    return status.isGranted;
  }

  /// Kamera izni kontrolü
  static Future<bool> _getCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      AppAlerts.showWarning(context, 'Kamera izni geçici olarak reddedildi.');
      return false;
    }
    if (status.isPermanentlyDenied) {
      AppAlerts.showWarning(context, 'Kamera izni kalıcı olarak reddedildi. Ayarlar açılıyor...');
      await openAppSettings();
      return false;
    }
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
