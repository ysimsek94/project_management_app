// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kisi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KisiModel _$KisiModelFromJson(Map<String, dynamic> json) => KisiModel(
      islemTarihi: json['islemTarihi'] as String?,
      kayitEden: json['kayitEden'] as String?,
      id: (json['id'] as num).toInt(),
      tcVergiNo: json['tcVergiNo'] as String?,
      adi: json['adi'] as String?,
      soyadi: json['soyadi'] as String?,
      babaAdi: json['babaAdi'] as String?,
      dogumTarihi: json['dogumTarihi'] as String?,
      cinsiyet: json['cinsiyet'] as String?,
      dogumYeri: json['dogumYeri'] as String?,
      ilceId: (json['ilceId'] as num?)?.toInt(),
      adres: json['adres'] as String?,
      ybsSicilNo: json['ybsSicilNo'] as String?,
      email: json['email'] as String?,
      telefon: json['telefon'] as String?,
      telefon2: json['telefon2'] as String?,
      vergiDairesi: json['vergiDairesi'] as String?,
      ehliyetTurId: (json['ehliyetTurId'] as num?)?.toInt(),
      ehliyetNo: json['ehliyetNo'] as String?,
      kanGrupId: (json['kanGrupId'] as num?)?.toInt(),
      egitimDurumId: (json['egitimDurumId'] as num?)?.toInt(),
      aciklama: json['aciklama'] as String?,
      iban: json['iban'] as String?,
      banka: json['banka'] as String?,
      sil: json['sil'] as bool?,
      nvi: json['nvi'] as bool?,
    );

Map<String, dynamic> _$KisiModelToJson(KisiModel instance) => <String, dynamic>{
      'islemTarihi': instance.islemTarihi,
      'kayitEden': instance.kayitEden,
      'id': instance.id,
      'tcVergiNo': instance.tcVergiNo,
      'adi': instance.adi,
      'soyadi': instance.soyadi,
      'babaAdi': instance.babaAdi,
      'dogumTarihi': instance.dogumTarihi,
      'cinsiyet': instance.cinsiyet,
      'dogumYeri': instance.dogumYeri,
      'ilceId': instance.ilceId,
      'adres': instance.adres,
      'ybsSicilNo': instance.ybsSicilNo,
      'email': instance.email,
      'telefon': instance.telefon,
      'telefon2': instance.telefon2,
      'vergiDairesi': instance.vergiDairesi,
      'ehliyetTurId': instance.ehliyetTurId,
      'ehliyetNo': instance.ehliyetNo,
      'kanGrupId': instance.kanGrupId,
      'egitimDurumId': instance.egitimDurumId,
      'aciklama': instance.aciklama,
      'iban': instance.iban,
      'banka': instance.banka,
      'sil': instance.sil,
      'nvi': instance.nvi,
    };
