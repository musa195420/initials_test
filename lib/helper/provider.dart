import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/view_models/authentication_view_model.dart';
import 'package:initial_test/view_models/login_view_model.dart';
import 'package:initial_test/view_models/signup_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderInjector {
  static List<SingleChildWidget> providers = [
    ..._independentServices,
    ..._dependentServices,
    ..._consumableServices,
  ];

  static final List<SingleChildWidget> _independentServices = [
    // ViewModels
    ChangeNotifierProvider(create: (_) => locator<AuthenticationViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<SignUpViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<LogInViewModel>()),
  ];

  static final List<SingleChildWidget> _dependentServices = [];

  static final List<SingleChildWidget> _consumableServices = [];
}
