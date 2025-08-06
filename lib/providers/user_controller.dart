import 'package:get/get.dart';
import 'package:initial_test/models/user_model.dart';
import 'package:initial_test/services/api_service.dart';
import 'package:initial_test/services/dialog_service.dart';

class UserController extends GetxController {
  final IApiService _apiService = Get.find<IApiService>();
  final IDialogService _dialogService = Get.find<IDialogService>();

  // Reactive variables
  var users = <UserModel>[].obs; // Observable list of users
  var isLoading = false.obs; // Observable loading flag
  var selectedUser = Rxn<UserModel>(); // Observable selected user (nullable)

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers(); // Fetch on controller init
  }

  Future<void> fetchAllUsers() async {
    isLoading.value = true;
    try {
      final userList = await _apiService.getAllUsers();
      users.assignAll(userList); // Updates the observable list
    } catch (e) {
      await _dialogService.showSuccess(text: "Error loading users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectUser(UserModel user) {
    selectedUser.value = user; // Update the observable selected user
  }
}
