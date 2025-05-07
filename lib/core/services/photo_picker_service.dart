import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Kamerayı açar ve fotoğraf çeker
  /// Android ve iOS platformlarında gerekli izinleri kontrol eder
  static Future<File?> pickFromCamera() async {
    if (kIsWeb) return null; // Web platformunda desteklenmez

    final permissionStatus = await Permission.camera.request();
    if (!permissionStatus.isGranted) {
      // Kamera izni verilmediğinde null döner
      return null;
    }

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      // Hata durumunda null döner
      return null;
    }
  }

  /// Galeriden tek fotoğraf seçer
  /// Android 13+ ve iOS 14+ için uygun izinleri kontrol eder
  static Future<File?> pickFromGallery() async {
    if (kIsWeb) return null; // Web platformunda desteklenmez

    final permissionGranted = await _getGalleryPermission();
    if (!permissionGranted) return null;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }

  /// Galeriden birden fazla fotoğraf seçer
  /// Android 13+ ve iOS 14+ için uygun izinleri kontrol eder
  static Future<List<File>> pickMultipleFromGallery() async {
    if (kIsWeb) return [];

    final permissionGranted = await _getGalleryPermission();
    if (!permissionGranted) return [];

    try {
      final pickedFiles = await _picker.pickMultiImage();
      return pickedFiles.map((e) => File(e.path)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Android ve iOS için galeriden fotoğraf erişim iznini kontrol eder
  /// Android 13+ için READ_MEDIA_IMAGES, önceki sürümler için storage izni ister
  static Future<bool> _getGalleryPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    } else if (Platform.isAndroid) {
      // Android 13 (API 33) ve üzeri için READ_MEDIA_IMAGES izni gereklidir
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

  /// Android sürümünü kontrol eder (13 ve üzeri için true döner)
  static Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;
    try {
      final sdkInt = await _getAndroidSdkInt();
      return sdkInt != null && sdkInt >= 33;
    } catch (_) {
      return false;
    }
  }

  /// Android SDK sürümünü alır (device_info_plus ile güncellendi)
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
