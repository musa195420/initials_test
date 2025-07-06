import 'package:hive/hive.dart';
import 'package:initial_test/models/base_model.dart';

part 'g/user_profile.g.dart'; // <-- run build_runner to generate this file

/// Make sure the `typeId` is **unique** across your entire code‑base.
/// (0 is already taken by `HiveUser`, so we start at 1 here.)
@HiveType(typeId: 1)
class UserProfile extends IHiveBaseModel<UserProfile> {
  // ─── Core identifiers ────────────────────────────────────────────────────────
  @HiveField(0)
  String? userId;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? password;

  // ─── Optional profile info ───────────────────────────────────────────────────
  @HiveField(3)
  String? fullName;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  int? roleId;

  @HiveField(6)
  String? profileImage;

  // ─── Constructors ────────────────────────────────────────────────────────────
  UserProfile({
    this.userId,
    this.email,
    this.password,
    this.fullName,
    this.phone,
    this.roleId,
    this.profileImage,
  });

  /// JSON → Dart
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['user_id'],
        email: json['email'],
        password: json['password'],
        fullName: json['full_name'],
        phone: json['phone'],
        roleId: json['role_id'],
        profileImage: json['profile_image'],
      );

  /// IHiveBaseModel — decode helper
  @override
  UserProfile fromJson(Map<String, dynamic> json) => UserProfile.fromJson(json);

  /// Dart → JSON
  @override
  Map<String, dynamic> toJson() => {
        if (userId?.isNotEmpty ?? false) 'userId': userId,
        if (email?.isNotEmpty ?? false) 'email': email,
        if (password?.isNotEmpty ?? false) 'password': password,
        if (fullName?.isNotEmpty ?? false) 'fullName': fullName,
        if (phone?.isNotEmpty ?? false) 'phone': phone,
        if (roleId != null) 'role_id': roleId,
        if (profileImage?.isNotEmpty ?? false) 'profile_image': profileImage,
      };
}
