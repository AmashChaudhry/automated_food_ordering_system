import 'package:automated_food_ordering_system/src/repository/authentication_repository.dart';
import 'package:automated_food_ordering_system/src/repository/user_repository.dart';
import 'package:get/get.dart';
import '../../authentication/models/user_model.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar('Error', 'Login to Continue');
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.allUser();
  }

  updateRecord(UserModel user) async {
   await _userRepo.updateUserRecord(user);
  }
}