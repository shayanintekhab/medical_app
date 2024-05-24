import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/global.dart';
import 'chat_controller.dart';
import 'message.dart';

class ChatMessagesScreen extends StatelessWidget {
  final String chatId;
  final ChatController _chatController = Get.find<ChatController>();

  ChatMessagesScreen({required this.chatId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _chatController.chatMessages.length,
                itemBuilder: (context, index) {
                  Message message = _chatController.chatMessages[index];
                  bool isSender = message.senderID == currentUserID;

                  return Align(
                    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: isSender ? Colors.blueAccent : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content ?? '',
                            style: TextStyle(
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _chatController.sendMessage(chatId, _controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
