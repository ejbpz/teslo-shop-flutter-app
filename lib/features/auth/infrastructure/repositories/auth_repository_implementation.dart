import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImplementation([AuthDatasource? authDatasource])
    : _authDatasource = authDatasource ?? AuthDatasourceImplementation();

  @override
  Future<User> checkAuthStatus(String token) {
    return _authDatasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return _authDatasource.login(email, password);
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    return _authDatasource.register(fullName, email, password);
  }

}