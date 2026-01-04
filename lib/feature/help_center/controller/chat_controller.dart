import 'dart:async';
import 'package:e_commerce_fullapp/feature/help_center/data/repository/chat_repository.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/message_model.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString chatRoomId = ''.obs;

  StreamSubscription? _messagesSubscription;

  String get currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    initChat();
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    super.onClose();
  }

  Future<void> initChat() async {
    try {
      isLoading.value = true;

      print('🔵 ChatController: بدء تحميل الدردشة');
      print('🔵 ChatController: currentUserId = $currentUserId');

      chatRoomId.value = await _repository.getOrCreateChatRoom(currentUserId);
      print('🔵 ChatController: chatRoomId = ${chatRoomId.value}');

      final previousMessages = await _repository.getMessages(chatRoomId.value);
      print('🔵 ChatController: عدد الرسائل = ${previousMessages.length}');

      messages.value =
          previousMessages.map((e) => MessageModel.fromJson(e)).toList();

      _listenToMessages();
      print('✅ ChatController: تم تحميل الدردشة بنجاح');
    } catch (e) {
      print('❌ ChatController Error: $e');
      Get.snackbar('خطأ', 'فشل في تحميل الدردشة: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToMessages() {
    _messagesSubscription =
        _repository.messagesStream(chatRoomId.value).listen((data) {
      messages.value = data.map((e) => MessageModel.fromJson(e)).toList();
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _repository.sendMessage(
        chatRoomId: chatRoomId.value,
        senderId: currentUserId,
        message: text.trim(),
        isAdmin: false,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الرسالة');
    }
  }
}
