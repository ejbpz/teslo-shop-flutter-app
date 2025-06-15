import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImplementation(AuthDatasource? authDatasource)
    : authDatasource = authDatasource ?? AuthDatasourceImplementation();

  @override
  Future<User> checkAuthStatus(String token) {
    return authDatasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    return authDatasource.register(fullName, email, password);
  }

}