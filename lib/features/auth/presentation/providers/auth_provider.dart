import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_implementation.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImplementation();
  final keyValueStorageService = KeyValueStorageServiceImplementation();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthRepositoryImplementation authRepository;
  KeyValueStorageServiceImplementation keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService
  }): super(AuthState()) {
    checkStatus();
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      errorMessage: null,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      User user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch(e) {
      logout(e.message);
    } catch (e) {
      logout('Unhandled error.');
    }
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage
    );
  }

  void registerUser(String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      User user = await authRepository.register(fullName, email, password);
      _setLoggedUser(user);
    } on CustomError catch(e) {
      logout(e.message);
    } catch (e) {
      logout('Unhandled error.');
    }
  }

  void checkStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if(token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }
}

enum AuthStatus {checking, authenticated, notAuthenticated}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}