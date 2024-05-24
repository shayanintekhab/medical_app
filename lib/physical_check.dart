import 'package:patient_app/scan_report.dart';

import 'widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'scan_device.dart';
import 'chat_controller.dart';

class PhysicalCheck extends StatefulWidget {
  @override
  State<PhysicalCheck> createState() => _PhysicalCheckState();
}

class _PhysicalCheckState extends State<PhysicalCheck> {
  final TextEditingController _keratininController = TextEditingController();
  final ChatController _chatController = Get.put(ChatController());

  void _checkConditionAndSendMessage() {
    double keratininLevel = double.tryParse(_keratininController.text) ?? 0.0;
    if (keratininLevel > 1.5) {
      _chatController.sendMessageToAllPatients(
          "Alert: Keratinin Level is above 1.5 mg/dL. Please review your patient.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/profile_logo.jpg'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Samaritan AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      'Scan using the button below to know more about your health.',
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () {
                      Get.to(ScanPage());
                    },
                    text: "Scan the Urinary Bag",
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () {
                      Get.to(ScanReport());
                    },
                    text: "Scan the Report",
                  ),
                  SizedBox(width: 30),
                  CustomButton(
                    onPressed: () {
                      Get.to(ScanPage());
                    },
                    text: "See Report",
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('Color'),
                        subtitle: Text('Normal'),
                        trailing: Icon(Icons.circle, color: Colors.green),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Keratinin Level'),
                        subtitle: TextField(
                          controller: _keratininController,
                          decoration: InputDecoration(
                            hintText: 'Enter Keratinin Level',
                          ),
                          onSubmitted: (value) {
                            _checkConditionAndSendMessage();
                          },
                        ),
                        trailing: Icon(Icons.circle, color: Colors.orange),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Blood Pressure'),
                        subtitle: Text('120/80 mmHg'),
                        trailing: Icon(Icons.circle, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 200,
                      child: CustomPaint(
                        painter: PieChartPainter(),
                        child: Center(
                          child: Text(
                            'Health Metrics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define paint object
    final paint = Paint()..style = PaintingStyle.fill;

    // Define the data for the pie chart
    final data = [40, 30, 20, 10];
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow];

    // Calculate the total value
    final total = data.reduce((a, b) => a + b);

    // Calculate the start angle and sweep angle for each section
    double startAngle = -90;
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 360;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        startAngle * (3.1415926535897932 / 180),
        sweepAngle * (3.1415926535897932 / 180),
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }


 @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
