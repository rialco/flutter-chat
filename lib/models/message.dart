
class Message {
  final String? id;
  final String senderId;
  final String receiverId;
  final String content;
  final int timestamp;

  Message(this.id, this.senderId, this.receiverId, this.content, this.timestamp);
}