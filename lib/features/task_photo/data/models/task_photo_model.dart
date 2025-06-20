import 'package:json_annotation/json_annotation.dart';

part 'task_photo_model.g.dart';

/// JSON-serializable models for TaskPhoto entity
@JsonSerializable()
class TaskPhotoModel {
  @JsonKey(defaultValue: '')
  final String islemTarihi;

  final String? kayitEden;
  final int id;
  final int fazId;
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

  TaskPhotoModel({
    required this.islemTarihi,
    this.kayitEden,
    required this.id,
    required this.fazId,
    required this.gorevId,
    this.aciklama,
    required this.docName,
    required this.docBinary,
    required this.thumbnailBinary,
    required this.uzanti,
  });

  /// Deserialize from JSON
  factory TaskPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$TaskPhotoModelFromJson(json);

  /// Serialize to JSON
  Map<String, dynamic> toJson() => _$TaskPhotoModelToJson(this);

  TaskPhotoModel copyWith({
    String? islemTarihi,
    String? kayitEden,
    int? id,
    int? fazId,
    int? gorevId,
    String? aciklama,
    String? docName,
    String? docBinary,
    String? thumbnailBinary,
    String? uzanti,
  }) {
    return TaskPhotoModel(
      islemTarihi: islemTarihi ?? this.islemTarihi,
      kayitEden: kayitEden ?? this.kayitEden,
      id: id ?? this.id,
      fazId: fazId ?? this.fazId,
      gorevId: gorevId ?? this.gorevId,
      aciklama: aciklama ?? this.aciklama,
      docName: docName ?? this.docName,
      docBinary: docBinary ?? this.docBinary,
      thumbnailBinary: thumbnailBinary ?? this.thumbnailBinary,
      uzanti: uzanti ?? this.uzanti,
    );
  }
}
