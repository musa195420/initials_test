import 'package:flutter/material.dart';
import 'package:initial_test/helper/app_constant.dart';
import 'package:initial_test/helper/error_handler.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';

class GlobalService {
  String tag = "Global Service";
  // PrefService get _prefService => locator<PrefService>();
  // LoggingService get _loggingService => locator<LoggingService>();
  // FavouriteViewmodel get favouriteViewmodel => locator<FavouriteViewmodel>();

  UserProfile? _user;
  UserProfile? getuser() {
    return _user;
  }

  setuser(UserProfile value) {
    _user = value;
  }

  Future<String> getHost() async {
    try {
      if (isProduction) {
        return server_url;
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }
    return server_url;
  }
}
