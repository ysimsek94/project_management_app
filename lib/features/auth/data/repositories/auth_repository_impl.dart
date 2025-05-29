import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login({required String tcKimlikNo, required String password}) async {
    final request = LoginRequestModel(
      tcKimlikNo: tcKimlikNo,
      password: password,
      serviceUserName: 'ProjeTakipApi',
      servicePassword: 'Proje@2025.',
    );
    final response = await remoteDataSource.login(request);

    return response;
  }
}