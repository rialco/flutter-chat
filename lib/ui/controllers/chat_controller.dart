import 'package:f_chat_template/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  var users = <ChatUser>[].obs;
  final uuid = const Uuid();

  final usersRef = FirebaseDatabase.instance.ref('users');
  final chatsRef = FirebaseDatabase.instance.ref('chats');


  createChats(currentUserId) {
    for (var user in users) { 
      createChat(currentUserId, user.id);
    }
  }

  createChat(senderId, receiverId) async {
    final chatId = uuid.v4();
    try {
      await chatsRef.child(chatId).set({
        "senderId": senderId,
        "receiverId": receiverId,
      });
      return chatId;
    } catch (e) {
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
      if ( data['senderId'] == senderId && data['receiverId'] == receiverId){
        return snap.key;
      }
    }

    return createChat(senderId, receiverId);
  }

  fetchChatUsers(currentUserId) {
    usersRef.onChildAdded.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      var newUser = ChatUser(event.snapshot.key.toString(), 'no name', data['email']);

      if (event.snapshot.key != currentUserId) users.add(newUser);
    });
  }

  cleanChatRoom() {
    users.clear();
  }
}
