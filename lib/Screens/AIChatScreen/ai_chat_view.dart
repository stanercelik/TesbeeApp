import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbee/Screens/AIChatScreen/ai_chat_viewmodel.dart';
import 'package:tesbee/Utils/color_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({Key? key}) : super(key: key);

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final AIChatViewModel aiChatViewModel = Get.put(AIChatViewModel());
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(l10n.aiHocaTitle,
            style: TextStyle(color: getTextColor(AppColors.primaryBackground))),
        backgroundColor: AppColors.primaryBackground,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: aiChatViewModel.scrollController,
                  itemCount: aiChatViewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = aiChatViewModel.messages[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: message.isUser
                          ? const EdgeInsets.fromLTRB(32, 8, 8, 8)
                          : const EdgeInsets.fromLTRB(8, 8, 32, 8),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? beadsViewModel.beadColor.value
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.content,
                          style: TextStyle(
                              fontSize: 16,
                              color: getTextColor(message.isUser
                                  ? beadsViewModel.beadColor.value
                                  : Colors.grey))),
                    );
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    cursorColor: beadsViewModel.beadColor.value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.typeYourQuestion,
                      hintStyle: const TextStyle(color: Colors.white30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: beadsViewModel.beadColor.value,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => aiChatViewModel.isLoading.value
                      ? CircularProgressIndicator(
                          color: beadsViewModel.beadColor.value,
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          color: beadsViewModel.beadColor.value,
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              aiChatViewModel
                                  .sendMessage(_messageController.text);
                              _messageController.clear();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
