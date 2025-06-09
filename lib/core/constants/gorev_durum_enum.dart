import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class GorevDurumEnumConverter implements JsonConverter<GorevDurumEnum, int> {
  const GorevDurumEnumConverter();

  @override
  GorevDurumEnum fromJson(int json) =>
      GorevDurumEnumHelper.fromId(json); // Buraya dikkat

  @override
  int toJson(GorevDurumEnum object) => object.id;
}

enum GorevDurumEnum {
  none,
  olusturuldu,
  atandi,
  devamEdiyor,
  tamamlandi,
  iptalEdildi,
}

extension GorevDurumEnumExtension on GorevDurumEnum {
  int get id {
    switch (this) {
      case GorevDurumEnum.none:
        return 0;
      case GorevDurumEnum.olusturuldu:
        return 1;
      case GorevDurumEnum.atandi:
        return 2;
      case GorevDurumEnum.devamEdiyor:
        return 3;
      case GorevDurumEnum.tamamlandi:
        return 4;
      case GorevDurumEnum.iptalEdildi:
        return 5;
    }
  }
  static GorevDurumEnum fromName(String name) {
    return GorevDurumEnum.values.firstWhere(
          (e) => e.label.toLowerCase() == name.toLowerCase(),
      orElse: () => GorevDurumEnum.none,
    );
  }
  Color get color {
    switch (this) {
      case GorevDurumEnum.olusturuldu:
        return Colors.blue;
      case GorevDurumEnum.atandi:
        return Colors.orange;
      case GorevDurumEnum.devamEdiyor:
        return Colors.green;
      case GorevDurumEnum.tamamlandi:
        return Colors.grey;
      case GorevDurumEnum.iptalEdildi:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
  String get label {
    switch (this) {
      case GorevDurumEnum.none:
        return 'Yok';
      case GorevDurumEnum.olusturuldu:
        return 'Olusturuldu';
      case GorevDurumEnum.atandi:
        return 'Atandı';
      case GorevDurumEnum.devamEdiyor:
        return 'DevamEdiyor';
      case GorevDurumEnum.tamamlandi:
        return 'Tamamlandi';
      case GorevDurumEnum.iptalEdildi:
        return 'IptalEdildi';
    }
  }
}

class GorevDurumEnumHelper {
  static GorevDurumEnum fromId(int id) {
    return GorevDurumEnum.values.firstWhere(
          (e) => e.id == id,
      orElse: () => GorevDurumEnum.none,
    );
  }
}