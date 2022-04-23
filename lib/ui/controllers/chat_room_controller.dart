import 'package:f_chat_template/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';


class ChatRoomController extends GetxController {
  var messages = <Message>[].obs;
  var uuid = const Uuid();
  final databaseRef = FirebaseDatabase.instance.ref('chats');

  var messageStream;

  fetchChatMessages(chatId) {
    messageStream = databaseRef.child('$chatId/messages').orderByChild('timestamp').onChildAdded.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      var message = Message(event.snapshot.key, data['senderId'], data['receiverId'], data['content'], data['timestamp']);
      print(message);
      messages.add(message);
    });
  }

  sendMessage(chatId, senderId, receiverId, content) async {
    final messageId = uuid.v4();
    try {
      var messageTimestamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseDatabase.instance.ref('chats/$chatId/messages/$messageId').set({
        "senderId": senderId,
        "receiverId": receiverId, 
        "content": content,
        "timestamp": messageTimestamp
      });
    } catch (e) {
      print('Error : $e');
      return null;
    }
    
  }

  createMessages(chatId, currentUserId, receiverId, receiverEmail) async {
    String name = receiverEmail.substring(0, receiverEmail.indexOf('@'));
    String messageOne = 'Hola! mi nombre es $name.';
    String messageTwo = 'Hola $name, mucho gusto.';

    var snapshot = await databaseRef.child('$chatId/messages').get();
    if ( snapshot.exists ) return;
    
    await sendMessage(chatId, receiverId, currentUserId, messageOne);
    await sendMessage(chatId, currentUserId, receiverId, messageTwo);
  }

  clearMessages() {
    messages.clear();
  }

  cancelStream() {
    messageStream.cancel();
  }
}
