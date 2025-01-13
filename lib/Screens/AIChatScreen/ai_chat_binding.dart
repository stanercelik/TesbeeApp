import 'package:get/get.dart';
import 'ai_chat_viewmodel.dart';

class AIChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AIChatViewModel());
  }
}
