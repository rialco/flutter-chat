import 'package:f_chat_template/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';


class ChatRoomController extends GetxController {
  var messages = <Message>[].obs;
  var uuid = const Uuid();
  final databaseRef = FirebaseDatabase.instance.ref('chats');

  fetchChatMessages(chatId) {
    databaseRef.child(chatId).onChildAdded.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      var message = Message(event.snapshot.key, data['senderId'], data['receiverId'], data['content']);

      messages.add(message);
    });
  }

  sendMessage(chatId, senderName, receiverName, content) async {
    final messageId = uuid.v4();
    await databaseRef.child(chatId).child(messageId).set({
      "senderId": senderName,
      "receiverId": receiverName, 
      "content": content
    }); 
  }

  createMessages(currentUserId, receiverId) async {

  }
}
