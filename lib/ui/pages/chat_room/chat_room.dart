import 'package:f_chat_template/ui/controllers/authentication_controller.dart';
import 'package:f_chat_template/ui/controllers/chat_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_chat_template/models/message.dart';

class ChatRoomPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final AuthenticationController authenticationController = Get.find();
  final ChatRoomController chatRoomController = Get.find();

  final String receiverEmail;
  final String receiverId;
  final String chatId;

  final Color _receiverColor = const Color.fromARGB(255, 234, 237, 255);
  final Color _senderColor = const Color.fromARGB(255, 243, 243, 243);

  ChatRoomPage({Key? key,  required this.receiverEmail, required this.receiverId, required this.chatId}) : super(key: key);

  _sendMessage(content) async {
    final currentUserId = authenticationController.getUid();
    await chatRoomController.sendMessage(chatId, currentUserId, receiverId, content);
  }

  Widget _textInput() {
    return Padding ( padding: const EdgeInsets.all(10), child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: TextField(
              key: const Key('MsgTextField'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your message',
              ),
              onSubmitted: (value) {
               _sendMessage(value); 
                _controller.clear();
              },
              controller: _controller,
            ),
          ),
        ),
        TextButton(
            key: const Key('sendButton'),
            child: const Text('Send'),
            onPressed: () {
              _sendMessage(_controller.text);
              _controller.clear();
            })
      ],
    ));
  }

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
          child: Column(
            children: [
              Expanded(
                flex: 4,
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
              ),
              _textInput()
            ],
          ) 
        ));
  }

  isMyMessage(Message message) {
    if( message.senderId == authenticationController.getUid()) return true;

    return false;
  }
}