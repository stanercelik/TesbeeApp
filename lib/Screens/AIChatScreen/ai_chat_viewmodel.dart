import 'package:get/get.dart';
import 'package:fal_client/fal_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AIChatViewModel extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final scrollController = ScrollController();
  late final FalClient fal;
  final l10n = AppLocalizations.of(Get.context!)!;

  @override
  void onInit() {
    super.onInit();
    try {
      fal = FalClient.withCredentials(
          "293a31fa-2a14-437e-b83e-da15a0394db9:6df9419b5874e9c70616dbcb86a00a30");
    } catch (e) {
      print("Error initializing FAL client: $e");
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      messages.add(ChatMessage(
        content: message,
        isUser: true,
      ));

      isLoading.value = true;
      print("Sending message to API...");

      try {
        final response = await fal.subscribe(
          "fal-ai/any-llm",
          input: {
            "model": "openai/gpt-4o-mini",
            "prompt": message,
            "system_prompt":
                "You are a virtual hodja providing religious guidance to users, blending traditional Islamic teachings with a modern perspective. You embrace values like inclusivity, compassion, and equality, aligning with contemporary ideas such as feminism and social justice. Address users appropriately, either singular or plural, based on the question, and organize your responses into clear sections with relevant headings, such as 'Dhikr Recommendation,' 'Dua Suggestion,' and 'Hadith or Wisdom.' Begin with a brief, inspiring introduction that connects the topic to modern values and encourages spiritual growth. Dhikr Recommendation (title is in the language of the prompt) Suggest a suitable dhikr and specify how many times it should be recited, with no additional explanations. Ensure it aligns with the user's potential emotional or spiritual state inferred from the question. write translates of the dhikrs in the language of the prompt Dua Suggestion (in the language of the prompt) Provide a meaningful supplication in Arabic written in the Latin alphabet, followed by a clear translation in the language of the question. Keep it concise and spiritually profound. Hadith or Wisdom (in the language of the prompt) Conclude with a relevant hadith, Quranic verse, or spiritual insight, emphasizing universal principles like kindness, empathy, and personal empowerment. Optionally, provide a short modern interpretation of how it relates to everyday life. Always maintain a kind, motivational tone, and ensure the response is concise, clear, and relatable to modern sensibilities. Respond in the language of the prompt. If the prompt is written in Turkish, respond in Turkish. If it is written in English, respond in English."
          },
          logs: true,
        );

        final responseData = response.data;
        final content = responseData['output'] ?? responseData.toString();
        if (content.isNotEmpty) {
          messages.add(ChatMessage(
            content: content,
            isUser: false,
          ));
        } else {
          throw Exception("Empty response content");
        }
      } catch (e) {
        debugPrint("Error in AI Chat: $e");
        debugPrint("Stack trace: ${StackTrace.current}");
        messages.add(ChatMessage(
          content: l10n.errorMessage,
          isUser: false,
        ));
      }
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
