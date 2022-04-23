import 'package:f_chat_template/ui/controllers/authentication_controller.dart';
import 'package:f_chat_template/ui/controllers/chat_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_chat_template/models/message.dart';

class ChatRoomPage extends StatelessWidget {
  
  final AuthenticationController authenticationController = Get.find();
  final ChatRoomController chatRoomController = Get.find();

  final String receiverEmail;
  final String chatId;

  final Color _receiverColor = const Color.fromARGB(255, 255, 253, 234);
  final Color _senderColor = const Color.fromARGB(255, 243, 243, 243);

  ChatRoomPage({Key? key,  required this.receiverEmail, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    chatRoomController.clearMessages();
    chatRoomController.fetchChatMessages(chatId);
    
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              chatRoomController.cancelStream();
              Navigator.pop(context, true);
            },
          ),
          title: Text("Chat with $receiverEmail"),
        ),
        body: SafeArea(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: chatRoomController.messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: isMyMessage(chatRoomController.messages[index]) ? _senderColor : _receiverColor, 
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(chatRoomController.messages[index].content, 
                        textAlign: isMyMessage(chatRoomController.messages[index]) ? TextAlign.right : TextAlign.left),
                    ),
                  );
                },
              )),
        ));
  }

  isMyMessage(Message message) {
    if( message.senderId == authenticationController.getUid()) return true;

    return false;
  }
}