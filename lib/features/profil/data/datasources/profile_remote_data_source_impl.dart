import 'package:project_management_app/core/network/api_service.dart';
import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;
  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProfileModel> fetchProfile(String userId) async {
   // final response = await apiService.get('/profile/$userId');
    //return ProfileModel.fromJson(response.data as Map<String, dynamic>);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock JSON data
    final mockJson = <String, dynamic>{
      'id': userId,
      'firstName': 'Yusuf',
      'lastName': 'Şimşek',
      'tckn': '12345678901',
    };
    return ProfileModel.fromJson(mockJson);
  }
}