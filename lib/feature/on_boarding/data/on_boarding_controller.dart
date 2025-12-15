import 'package:e_commerce_fullapp/feature/home/view/home_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;
  final box = GetStorage();

  void nextPage() {
    if (pageIndex.value == 2) {
      finishOnboarding();
    } else {
      pageIndex.value++;
    }
  }

  void skip() {
    finishOnboarding();
  }

  void finishOnboarding() {
    box.write('seenOnboard', true);
    Get.off(() => const HomeView());
  }
}
