import 'package:f_chat_template/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  var users = <ChatUser>[].obs;
  final uuid = const Uuid();

  final usersRef = FirebaseDatabase.instance.ref('users');
  final chatsRef = FirebaseDatabase.instance.ref('chats');

  createChat(senderId, receiverId) async {
    final chatId = uuid.v4();
    try {
      await chatsRef.child('$chatId/participants').set({
        0: senderId,
        1: receiverId,
      });
      return chatId;
    } catch (e) {
      print('Error creando chat: $e');
      return null;
    }
  }

  getChatId(senderId, receiverId) async {
    final snapshots = await chatsRef.get();
    
    if (!snapshots.exists) {
      return createChat(senderId, receiverId);
    }

    for (var snap in snapshots.children) { 
      final data = snap.value as Map<dynamic, dynamic>; 
      final participants = data['participants'] as List;
    
      var validChat = participants.every((id) => id == senderId || id == receiverId);

      if ( validChat ) {  
        return snap.key;
      }
    }

    return createChat(senderId, receiverId);
  }

  fetchChatUsers(currentUserId) {
    usersRef.onChildAdded.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      var newUser = ChatUser(event.snapshot.key.toString(), 'no name', data['email']);

      if (event.snapshot.key != currentUserId && !users.contains(newUser)) users.add(newUser);
    });
  }

  cleanChatRoom() {
    users.clear();
  }
}
