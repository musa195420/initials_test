import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/models/helper_models/api_response.dart';
import 'package:initial_test/models/helper_models/api_status.dart';
import 'package:initial_test/models/helper_models/error_response.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/models/request_model/login_request.dart';
import 'package:initial_test/models/request_model/ride_model.dart';
import 'package:initial_test/models/response_models/refresh_response.dart';
import 'package:initial_test/services/http_service.dart';

import '../../models/user_model.dart';

class ApiServiceImpl implements IApiService {
  HttpService get _httpService => locator<HttpService>();

  String tag = "API Service";
  @override
  Future<ApiStatus> login(LoginRequest login) async {
    try {
      var response =
          await _httpService.postData("api/auth/login", login.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: RefreshTokenResponse.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  Future<ApiStatus> signup(UserProfile user) async {
    try {
      var response =
          await _httpService.postData("api/auth/register", user.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> getRoles() async {
    try {
      var response = await _httpService.getData("api/role");
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> getRides(UserProfile user) async {
    try {
      var response = await _httpService.getData("api/ride/by-user");
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> refreshToken(RefreshTokenResponse refresh) async {
    try {
      var response =
          await _httpService.postData("api/auth/refresh", refresh.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: RefreshTokenResponse.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> registerProfile(UserProfile user) async {
    try {
      var response =
          await _httpService.postData("api/auth/register", user.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> getUserProfileByEmail(UserProfile user) async {
    try {
      var response =
          await _httpService.postData("api/profile/email", user.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: UserProfile.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> addride(RideModel ride) async {
    try {
      var response = await _httpService.postData("api/ride", ride.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        if (res.success ?? true) {
          return ApiStatus(
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }

  @override
  Future<ApiStatus> updateride(RideModel ride) async {
    try {
      var response = await _httpService.patchData("api/ride", ride.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
      }
    } on HttpException catch (e, s) {
      return ApiStatus(data: e, errorCode: "PA0013");
    } on FormatException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0007");
    } on TimeoutException catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);

      return ApiStatus(data: e, errorCode: "PA0003");
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
      return ApiStatus(data: e, errorCode: "PA0006");
    }
  }
}

sealed class IApiService {
  Future<ApiStatus> login(LoginRequest login);
  Future<ApiStatus> refreshToken(RefreshTokenResponse refresh);
  Future<ApiStatus> registerProfile(UserProfile user);
  Future<ApiStatus> getUserProfileByEmail(UserProfile user);
  Future<ApiStatus> getRoles();
  Future<ApiStatus> addride(RideModel ride);
  Future<ApiStatus> updateride(RideModel ride);
  Future<ApiStatus> getRides(UserProfile user);
}
