import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ScanReport extends StatefulWidget {
  @override
  _ScanReportState createState() => _ScanReportState();
}

class _ScanReportState extends State<ScanReport> {
  bool isLoading = false;
  List<String> result = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await sendImageToApi(pickedFile.path);
        setState(() {
          result = response;
        });
      } catch (e) {
        setState(() {
          result = ['Error: Unable to process the image.'];
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<String>> sendImageToApi(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://your-api-endpoint.com/analyze'), // Replace with your API endpoint
    );
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final resultData = jsonDecode(responseData);
      // Assuming the API returns a list of strings
      return List<String>.from(resultData['results']);
    } else {
      // Handle error
      return ['Error: ${response.reasonPhrase}'];
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showImageSourceActionSheet(context),
              child: const Text('Upload or Click a Photo of the Report'),
            ),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator()
            else if (result.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(result[index]),
                    );
                  },
                ),
              )
            else
              const Text('No result'),
          ],
        ),
      ),
    );
  }
}


