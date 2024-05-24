import 'message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    this.id,
    this.participants,
    this.messages,
  });

  static Chat fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;
    return Chat(
      id: dataSnapshot['id'],
      participants: List<String>.from(dataSnapshot['participants']),
      messages: List<Message>.from(
        dataSnapshot['messages'].map((m) => Message.fromJson(m))
      ),
    );
  }

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages = List<Message>.from(
      json['messages'].map((m) => Message.fromJson(m))
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'participants': participants,
        'messages': messages?.map((m) => m.toJson()).toList() ?? [],
      };
}
