import 'dart:async';
import 'dart:io';
import 'package:e_commerce_fullapp/feature/help_center/data/repository/chat_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/message_model.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString chatRoomId = ''.obs;
  final RxBool isRecording = false.obs;
  final RxBool isSendingMedia = false.obs;
  final RxInt recordingDuration = 0.obs;

  StreamSubscription? _messagesSubscription;
  Timer? _recordingTimer;
  String? _recordingPath;

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
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
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

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        await _sendImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        await _sendImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في التقاط الصورة');
    }
  }

  Future<void> _sendImage(File imageFile) async {
    try {
      isSendingMedia.value = true;
      await _repository.sendImageMessage(
        chatRoomId: chatRoomId.value,
        senderId: currentUserId,
        imageFile: imageFile,
        isAdmin: false,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الصورة');
    } finally {
      isSendingMedia.value = false;
    }
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _recordingPath =
            '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _recordingPath!,
        );

        isRecording.value = true;
        recordingDuration.value = 0;

        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingDuration.value++;
        });
      } else {
        Get.snackbar('خطأ', 'يرجى السماح بالوصول إلى الميكروفون');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في بدء التسجيل');
    }
  }

  Future<void> stopRecording({bool send = true}) async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();
      isRecording.value = false;

      if (send && path != null && recordingDuration.value > 0) {
        await _sendVoiceMessage(File(path), recordingDuration.value);
      }

      recordingDuration.value = 0;
      _recordingPath = null;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إيقاف التسجيل');
    }
  }

  Future<void> cancelRecording() async {
    await stopRecording(send: false);
  }

  Future<void> _sendVoiceMessage(File voiceFile, int durationSeconds) async {
    try {
      isSendingMedia.value = true;
      await _repository.sendVoiceMessage(
        chatRoomId: chatRoomId.value,
        senderId: currentUserId,
        voiceFile: voiceFile,
        durationSeconds: durationSeconds,
        isAdmin: false,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الرسالة الصوتية');
      print('❌ Error sending voice message: $e');
    } finally {
      isSendingMedia.value = false;
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        await _sendFile(file, fileName, fileSize);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الملف');
    }
  }

  Future<void> _sendFile(File file, String fileName, int fileSize) async {
    try {
      isSendingMedia.value = true;
      await _repository.sendFileMessage(
        chatRoomId: chatRoomId.value,
        senderId: currentUserId,
        file: file,
        fileName: fileName,
        fileSizeBytes: fileSize,
        isAdmin: false,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الملف');
    } finally {
      isSendingMedia.value = false;
    }
  }

  String formatRecordingDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _repository.deleteMessage(messageId);
      Get.snackbar('نجاح', 'تم حذف الرسالة');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف الرسالة');
    }
  }

  Future<void> updateMessage(String messageId, String newMessage) async {
    if (newMessage.trim().isEmpty) return;
    try {
      await _repository.updateMessage(messageId, newMessage.trim());
      Get.snackbar('نجاح', 'تم تعديل الرسالة');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تعديل الرسالة');
    }
  }

  bool canEditOrDeleteMessage(MessageModel message) {
    return message.senderId == currentUserId && !message.isDeleted;
  }
}
