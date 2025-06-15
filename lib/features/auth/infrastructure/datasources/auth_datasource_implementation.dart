import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImplementation extends AuthDatasource {
  final dio = Dio(
    BaseOptions (
      baseUrl: Environment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        }
      );

      return UserMapper.jsonToUser(LoginResponse.fromJson(response.data));
    } catch (e) {
      throw WrongCredentials();
    }
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    throw UnimplementedError();
  }

}