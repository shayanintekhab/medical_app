import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image }

class Message {
  String? senderID;
  String? content;
  MessageType? messageType;
  Timestamp? sentAt;
  String? imageUrl;

  Message({
    this.senderID,
    this.content,
    this.messageType,
    this.sentAt,
    this.imageUrl
  });

  Message.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    content = json['content'];
    sentAt = json['sentAt'];
    messageType = MessageType.values.byName(json['messageType']);
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() => {
        'senderID': senderID,
        'content': content,
        'sentAt': sentAt,
        'messageType': messageType?.name,
        'imageUrl': imageUrl,
      };
}
