import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
}