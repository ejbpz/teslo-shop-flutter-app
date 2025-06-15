import 'package:teslo_shop/features/auth/infrastructure/models/login_response.dart';

import '../../domain/domain.dart';

class UserMapper {
  static User jsonToUser(LoginResponse response) => User(
    id: response.id, 
    email: response.email, 
    fullName: response.fullName, 
    token: response.token, 
    roles: response.roles
  );
}