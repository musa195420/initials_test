import 'package:initial_test/models/base_model.dart';

class RefreshTokenResponse extends IBaseModel<RefreshTokenResponse> {
  bool? success;
  String? message;
  String? accessToken;
  String? refreshToken;
  String? expiresAt; // New field

  RefreshTokenResponse({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        success: json['success'],
        message: json['message'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresAt: json['expiresAt'],
      );

  @override
  RefreshTokenResponse fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        if (success != null) 'success': success,
        if (message != null) 'message': message,
        if (accessToken != null) 'accessToken': accessToken,
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (expiresAt != null) 'expiresAt': expiresAt,
      };
}
