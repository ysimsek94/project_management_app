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

  String get label {
    switch (this) {
      case GorevDurumEnum.none:
        return 'Yok';
      case GorevDurumEnum.olusturuldu:
        return 'Oluşturuldu';
      case GorevDurumEnum.atandi:
        return 'Atandı';
      case GorevDurumEnum.devamEdiyor:
        return 'Devam Ediyor';
      case GorevDurumEnum.tamamlandi:
        return 'Tamamlandı';
      case GorevDurumEnum.iptalEdildi:
        return 'İptal Edildi';
    }
  }

  static GorevDurumEnum fromId(int id) {
    return GorevDurumEnum.values.firstWhere(
          (e) => e.id == id,
      orElse: () => GorevDurumEnum.none,
    );
  }
}