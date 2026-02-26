import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel {
  final String id;
  final String? email;

  const AuthUserModel({required this.id, this.email});

  factory AuthUserModel.fromSupabase(User user) {
    return AuthUserModel(id: user.id, email: user.email);
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(id: id, email: email);
  }
}
