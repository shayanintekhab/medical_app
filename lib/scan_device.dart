import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPage extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Urinary Bag'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: controller.pickImage,
              child: const Text('Click a Photo of the Bag'),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else if (controller.result.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.result.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller.result[index]),
                      );
                    },
                  ),
                );
              } else {
                return const Text('No result');
              }
            }),
          ],
        ),
      ),
    );
  }
}

class ScanController extends GetxController {
  var isLoading = false.obs;
  var result = <String>[].obs;
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic("dp0aoo7tm", 'm3swo7hq',
      cache:
          false); // Replace with your Cloudinary cloud name and upload preset

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      isLoading(true);
      final cloudinaryUrl = await uploadImageToCloudinary(pickedFile.path);
      print(cloudinaryUrl);
      final response = await sendImageToApi(cloudinaryUrl);
      result.assignAll(response);
      isLoading(false);
    }
  }

  Future<String> uploadImageToCloudinary(String imagePath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      throw e;
    }
  }

  Future<List<String>> sendImageToApi(String imageUrl) async {
    final apiUrl = 'YOUR_API_ENDPOINT'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imageUrl': imageUrl}),
    );

    if (response.statusCode == 200) {
      // Assuming the API returns a JSON array of strings
      List<String> apiResponse = List<String>.from(jsonDecode(response.body));

      // Rearrange the values according to "R", "G", "B", and "Volume"
      List<String> rearrangedValues = ['R', 'G', 'B', 'Volume']
          .map((key) => apiResponse.firstWhere((element) => element == key,
              orElse: () => 'N/A'))
          .toList();

      return rearrangedValues;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
