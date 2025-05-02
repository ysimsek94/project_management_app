import '../datasources/auth_remote_data_source.dart';
import '../models/login_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({required String email, required String password}) async {
    final request = LoginRequestModel(email: email, password: password);
    final response = await remoteDataSource.login(request);

    return User(username: response.username, token: response.token, adSoyad:response.adSoyad);
  }
}