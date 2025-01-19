import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trueline_news_media/app/constants/hive_table_constant.dart';
import 'package:trueline_news_media/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.studentTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? studentId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  AuthHiveModel({
    String? studentId,
    required this.fullName,
    required this.email,
    required this.password,
  }) : studentId = studentId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : studentId = '',
        fullName = '',
        email = '',
        password = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      studentId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: studentId,
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [studentId, fullName, email, password];
}
