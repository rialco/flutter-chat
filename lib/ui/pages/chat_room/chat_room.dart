import 'package:f_chat_template/ui/controllers/authentication_controller.dart';
import 'package:f_chat_template/ui/controllers/chat_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPage extends StatelessWidget {
  
  final AuthenticationController authenticationController = Get.find();
  final ChatRoomController chatRoomController = Get.find();

  final String receiverEmail;
  final String chatId;

  ChatRoomPage({Key? key,  required this.receiverEmail, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    chatRoomController.fetchChatMessages(authenticationController.getUid());
    
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white
          ),
          title: Text("Chat with $receiverEmail"),
        ),
        body: SafeArea(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: chatRoomController.messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(chatRoomController.messages[index].content),
                    ),
                  );
                },
              )),
        ));
  }
}