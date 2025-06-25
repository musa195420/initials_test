import 'package:hive/hive.dart';
import 'package:initial_test/models/base_model.dart';

part 'g/hive_user.g.dart';

@HiveType(typeId: 0)
class HiveUser extends IHiveBaseModel<HiveUser> {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? password;

  HiveUser({
    required this.userId,
    this.email,
    this.phoneNumber,
    this.password,
  });

  factory HiveUser.fromJson(Map<String, dynamic> json) => HiveUser(
        userId: json["userId"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        password: json["password"],
      );

  @override
  HiveUser fromJson(Map<String, dynamic> json) => HiveUser.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
      };
}
