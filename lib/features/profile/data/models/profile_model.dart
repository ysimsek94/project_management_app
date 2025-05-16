import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required String id,
    required String firstName,
    required String lastName,
    required String tckn,
  }) : super(id: id, firstName: firstName, lastName: lastName, tckn: tckn);

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    tckn: json['tckn'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'tckn': tckn,
  };
}