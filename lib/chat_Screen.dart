import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatScreen1 extends StatefulWidget {
  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final ChatController _chatController = Get.put(ChatController());
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors' Messages"),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (_chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Filtered list of doctors based on search query
          List<Map<String, dynamic>> filteredDoctors = _chatController.patientsData.where((doctor) {
            String name = doctor['name'].toLowerCase();
            String searchQuery = searchController.text.toLowerCase();
            return name.contains(searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {}); // Update UI when search query changes
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Doctors',
      
                    
                    prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 32, 31, 31)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: Icon(Icons.clear, color: const Color.fromARGB(255, 35, 35, 35)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 252, 252, 253)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    var doctor = filteredDoctors[index];
                    bool hasNewMessage = _chatController.newMessageMap[doctor['uid']] ?? false;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 240, 230, 230).withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(doctor['image']),
                            ),
                            if (hasNewMessage)
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          doctor['name'],
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('Phone No.: ${doctor['phoneNo']}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                          ],
                        ),
                        onTap: () {
                          _chatController.checkAndOpenChat(doctor['uid']);
                          _chatController.newMessageMap[doctor['uid']] = false; // Mark as read
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
