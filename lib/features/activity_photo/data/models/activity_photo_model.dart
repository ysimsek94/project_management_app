import 'package:json_annotation/json_annotation.dart';

part 'activity_photo_model.g.dart';

/// JSON-serializable models for ActivityPhoto entity
@JsonSerializable()
class ActivityPhotoModel {
  @JsonKey(defaultValue: '')
  final String islemTarihi;
  final String? kayitEden;
  final int id;
  final int faliyetId;
  final int gorevId;
  final String? aciklama;

  @JsonKey(defaultValue: '')
  final String docName;

  @JsonKey(defaultValue: '')
  final String docBinary;

  @JsonKey(defaultValue: '')
  final String thumbnailBinary;

  @JsonKey(defaultValue: '')
  final String uzanti;

  ActivityPhotoModel({
    required this.islemTarihi,
    this.kayitEden,
    required this.id,
    required this.faliyetId,
    required this.gorevId,
    this.aciklama,
    required this.docName,
    required this.docBinary,
    required this.thumbnailBinary,
    required this.uzanti,
  });

  /// Deserialize from JSON
  factory ActivityPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityPhotoModelFromJson(json);

  /// Serialize to JSON
  Map<String, dynamic> toJson() => _$ActivityPhotoModelToJson(this);

  ActivityPhotoModel copyWith({
    String? islemTarihi,
    String? kayitEden,
    int? id,
    int? faliyetId,
    int? gorevId,
    String? aciklama,
    String? docName,
    String? docBinary,
    String? thumbnailBinary,
    String? uzanti,
  }) {
    return ActivityPhotoModel(
      islemTarihi: islemTarihi ?? this.islemTarihi,
      kayitEden: kayitEden ?? this.kayitEden,
      id: id ?? this.id,
      faliyetId: faliyetId ?? this.faliyetId,
      gorevId: gorevId ?? this.gorevId,
      aciklama: aciklama ?? this.aciklama,
      docName: docName ?? this.docName,
      docBinary: docBinary ?? this.docBinary,
      thumbnailBinary: thumbnailBinary ?? this.thumbnailBinary,
      uzanti: uzanti ?? this.uzanti,
    );
  }
}
