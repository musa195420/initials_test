import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final Rxn<User> userRx = Rxn<User>(); // Rxn allows null

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      userRx.value = user;
    });
  }
}
