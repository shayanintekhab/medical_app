import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'message.dart';
import 'chat_message_screen.dart';

class ChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var patientsData = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var chatMessages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCurrentUserPatients();
    _setupMessageListener();
  }

  Future<void> _fetchCurrentUserPatients() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doctorSnapshot =
            await _firestore.collection('patients').doc(currentUser.uid).get();

        List<dynamic> patientsUIDs = doctorSnapshot['doctors'];

        List<Map<String, dynamic>> loadedPatientsData = [];

        for (String patientUID in patientsUIDs) {
          DocumentSnapshot patientSnapshot =
              await _firestore.collection('doctors').doc(patientUID).get();
          if (patientSnapshot.exists) {
            loadedPatientsData.add({
              'uid': patientSnapshot.id,
              'name': patientSnapshot['name'],
              'image': patientSnapshot['imageProfile'],
              'phoneNo':patientSnapshot['phoneNumber']
            });
          }
        }

        patientsData.value = loadedPatientsData;
      }
    } catch (e) {
      print('Error fetching patients: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAndOpenChat(String patientUID) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String chatId = _generateChatId(currentUser.uid, patientUID);

      DocumentSnapshot chatSnapshot =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatSnapshot.exists) {
        // Chat exists
        Chat chat = Chat.fromDataSnapshot(chatSnapshot);
        chatMessages.value = chat.messages ?? [];
        Get.to(() => ChatMessagesScreen(chatId: chat.id!));
      } else {
        // No chat exists, create new chat
        Chat newChat = Chat(
          id: chatId,
          participants: [currentUser.uid, patientUID],
          messages: [],
        );
        await _firestore.collection('chats').doc(chatId).set(newChat.toJson());
        Get.to(() => ChatMessagesScreen(chatId: chatId));
      }
    }
  }

  Future<void> sendMessage(String chatId, String messageText) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      Message message = Message(
        senderID: currentUser.uid,
        content: messageText,
        messageType: MessageType.Text,
        sentAt: Timestamp.now(),
      );

      await _firestore.collection('chats').doc(chatId).update({
        'messages': FieldValue.arrayUnion([message.toJson()]),
      });

      chatMessages.add(message);
    }
  }

  Future<void> sendMessageToAllPatients(String messageText) async {
    for (var patient in patientsData) {
      await checkAndOpenChat(patient['uid']);
      await sendMessage(_generateChatId(_auth.currentUser!.uid, patient['uid']), messageText);
    }
  }

  String _generateChatId(String uid1, String uid2) {
    List<String> sortedUids = [uid1, uid2]..sort();
    return sortedUids.join('_');
  }


  var newMessageMap = <String, bool>{}.obs; // Track new messages


  void _setupMessageListener() {
    FirebaseFirestore.instance.collection('chats').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var chat = Chat.fromDataSnapshot(doc);
        for (var message in chat.messages ?? []) {
          if (message.sentAt != null && message.sentAt!.toDate().isAfter(DateTime.now().subtract(Duration(seconds: 5)))) {
            newMessageMap[chat.id!] = true;
          }
        }
      }
    });
  }

}
