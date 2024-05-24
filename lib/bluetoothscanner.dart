// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class BluetoothExample extends StatefulWidget {
//   @override
//   _BluetoothExampleState createState() => _BluetoothExampleState();
// }

// class _BluetoothExampleState extends State<BluetoothExample> {
//   final FlutterBluePlus flutterBlue = FlutterBluePlus();
//   List<Map<String, dynamic>> discoveredDevices = [];
//   BluetoothDevice? connectedDevice;
//   List<BluetoothService> services = [];

//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }

//   @override
//   void dispose() {
//     FlutterBluePlus.stopScan();
//     super.dispose();
//   }

//   void startScan() {
//     print("Starting Bluetooth device scan...");
//     discoveredDevices.clear();

//     FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

//     FlutterBluePlus.scanResults.listen(
//       (results) {
//         print("Scan results: ${results.length} devices found");
//         setState(() {
//           for (ScanResult result in results) {
//             String deviceName = result.device.name.isEmpty ? "Unnamed device" : result.device.name;
//             AdvertisementData advertisementData = result.advertisementData;
//             Map<String, dynamic> deviceInfo = {
//               'name': deviceName,
//               'id': result.device.remoteId.toString(),
//               'device': result.device,
//               'rssi': result.rssi,
//               'advertisementData': {
//                 'localName': advertisementData.advName,
//                 'manufacturerData': advertisementData.manufacturerData,
//                 'serviceData': advertisementData.serviceData,
//                 'serviceUuids': advertisementData.serviceUuids,
//                 'txPowerLevel': advertisementData.txPowerLevel,
//                 'connectable': advertisementData.connectable,
//               }
//             };
//             print("Discovered device: $deviceInfo");
//             discoveredDevices.add(deviceInfo);
//           }
//         });
//       },
//       onError: (error) {
//         print("Scan failed with error: $error");
//       },
//     );

//     FlutterBluePlus.isScanning.listen((isScanning) {
//       print("Scanning Status: ${isScanning ? "Scanning" : "Not scanning"}");
//     });
//   }

//   Future<void> connectToDevice(BluetoothDevice device) async {
//     setState(() {
//       connectedDevice = device;
//     });

//     try {
//       await device.connect(autoConnect: false);
//     } on FlutterBluePlusException catch (e) {
//       if (e.code == 'connect') {
//         print('Connection failed with error 133, retrying...');
//         await Future.delayed(Duration(seconds: 2));
//         try {
//           await device.connect(autoConnect: false);
//         } on FlutterBluePlusException catch (e) {
//           print('Retry failed with error: $e');
//           setState(() {
//             connectedDevice = null;
//           });
//           return;
//         }
//       } else {
//         print('Connection failed with error: $e');
//         setState(() {
//           connectedDevice = null;
//         });
//         return;
//       }
//     }

//     print("Connected to device: ${device.platformName}");

//     // Discover services after connecting to the device
//     services = await device.discoverServices();

//     for (BluetoothService service in services) {
//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         if (characteristic.properties.notify) {
//           await characteristic.setNotifyValue(true);
//           characteristic.lastValueStream.listen((value) {
//             print("Received data: $value from ${characteristic.uuid}");
//             // Parse and display urine amount data here
//             displayUrineAmount(value);
//           });
//         }
//       }
//     }

//     setState(() {});
//   }

//   void displayUrineAmount(List<int> value) {
//     // Parse urine amount data from the value and display it
//     // For example, if value is in a specific format like [0, 100, 50], where the first byte represents the type of data and the next two bytes represent the urine amount, you can parse it accordingly
//     if (value.length >= 3 && value[0] == 0) {
//       int urineAmount = (value[1] << 8) | value[2];
//       print("Urine amount: $urineAmount ml");
//       // Update UI to display urine amount
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Device Scanner'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: discoveredDevices.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> device = discoveredDevices[index];
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(device['name']),
//                     subtitle: Text(
//                       'ID: ${device['id']}\nRSSI: ${device['rssi']}\n'
//                       'Advertisement Data:\n'
//                       '  Local Name: ${device['advertisementData']['localName']}\n'
//                       '  Manufacturer Data: ${device['advertisementData']['manufacturerData']}\n'
//                       '  Service Data: ${device['advertisementData']['serviceData']}\n'
//                       '  Service UUIDs: ${device['advertisementData']['serviceUuids']}\n'
//                       '  TX Power Level: ${device['advertisementData']['txPowerLevel']}\n'
//                       '  Connectable: ${device['advertisementData']['connectable']}\n',
//                     ),
//                     onTap: () {
//                       connectToDevice(device['device']);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (connectedDevice != null)
//             Column(
//               children: [
//                 Text("Connected to ${connectedDevice!.advName}"),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await connectedDevice!.disconnect();
//                     setState(() {
//                       connectedDevice = null;
//                       services.clear();
//                     });
//                   },
//                   child: Text('Disconnect'),
//                 ),
//               ],
//             ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ElevatedButton(
//               onPressed: () async {
//                 bool isScanning = await FlutterBluePlus.isScanning.first;
//                 if (isScanning) {
//                   FlutterBluePlus.stopScan();
//                   print("Scan stopped by user.");
//                 } else {
//                   startScan();
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//               ),
//               child: Text(
//                 'Scan',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothExample extends StatefulWidget {
  @override
  _BluetoothExampleState createState() => _BluetoothExampleState();
}

class _BluetoothExampleState extends State<BluetoothExample> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<Map<String, dynamic>> discoveredDevices = [];
  Set<String> uniqueRemoteIds = {}; // Track unique remote IDs
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void startScan() {
    print("Starting Bluetooth device scan...");
    discoveredDevices.clear();
    uniqueRemoteIds.clear();

    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen(
      (results) {
        print("Scan results: ${results.length} devices found");
        setState(() {
          for (ScanResult result in results) {
            String remoteId = result.device.remoteId.toString();
            if (!uniqueRemoteIds.contains(remoteId)) {
              uniqueRemoteIds.add(remoteId);
              String deviceName = result.device.name.isEmpty ? "Unnamed device" : result.device.name;
              AdvertisementData advertisementData = result.advertisementData;
              Map<String, dynamic> deviceInfo = {
                'name': deviceName,
                'id': remoteId,
                'device': result.device,
                'rssi': result.rssi,
                'advertisementData': {
                  'localName': advertisementData.advName,
                  'manufacturerData': advertisementData.manufacturerData,
                  'serviceData': advertisementData.serviceData,
                  'serviceUuids': advertisementData.serviceUuids,
                  'txPowerLevel': advertisementData.txPowerLevel,
                  'connectable': advertisementData.connectable,
                }
              };
              print("Discovered device: $deviceInfo");
              discoveredDevices.add(deviceInfo);
            }
          }
        });
      },
      onError: (error) {
        print("Scan failed with error: $error");
      },
    );

    FlutterBluePlus.isScanning.listen((isScanning) {
      print("Scanning Status: ${isScanning ? "Scanning" : "Not scanning"}");
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    setState(() {
      connectedDevice = device;
    });

    try {
      await device.connect(autoConnect: false);
    } on FlutterBluePlusException catch (e) {
      if (e.code == 'connect') {
        print('Connection failed with error 133, retrying...');
        await Future.delayed(Duration(seconds: 2));
        try {
          await device.connect(autoConnect: false);
        } on FlutterBluePlusException catch (e) {
          print('Retry failed with error: $e');
          setState(() {
            connectedDevice = null;
          });
          return;
        }
      } else {
        print('Connection failed with error: $e');
        setState(() {
          connectedDevice = null;
        });
        return;
      }
    }

    print("Connected to device: ${device.remoteId}");

    // Discover services after connecting to the device
    services = await device.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.lastValueStream.listen((value) {
            print("Received data: $value from ${characteristic.uuid}");
            // Parse and display urine amount data here
            displayUrineAmount(value);
          });
        }
      }
    }

    setState(() {});
  }

  void displayUrineAmount(List<int> value) {
    // Parse urine amount data from the value and display it
    // For example, if value is in a specific format like [0, 100, 50], where the first byte represents the type of data and the next two bytes represent the urine amount, you can parse it accordingly
    if (value.length >= 3 && value[0] == 0) {
      int urineAmount = (value[1] << 8) | value[2];
      print("Urine amount: $urineAmount ml");
      // Update UI to display urine amount
    }
  }

  void searchById(String id) {
    setState(() {
      discoveredDevices = discoveredDevices.where((device) => device['id'].contains(id)).toList();
    });
  }

  void updateSearch(String query) {
    searchById(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Device Scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              onChanged: updateSearch,
              decoration: InputDecoration(
                labelText: 'Search by ID',
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    updateSearch('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> device = discoveredDevices[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(device['name']),
                    subtitle: Text(
                      'ID: ${device['id']}\nRSSI: ${device['rssi']}\n'
                      'Advertisement Data:\n'
                      '  Local Name: ${device['advertisementData']['localName']}\n'
                      '  Manufacturer Data: ${device['advertisementData']['manufacturerData']}\n'
                      '  Service Data: ${device['advertisementData']['serviceData']}\n'
                      '  Service UUIDs: ${device['advertisementData']['serviceUuids']}\n'
                      '  TX Power Level: ${device['advertisementData']['txPowerLevel']}\n'
                      '  Connectable: ${device['advertisementData']['connectable']}\n',
                    ),
                    onTap: () {
                      connectToDevice(device['device']);
                    },
                  ),
                );
              },
            ),
          ),
          if (connectedDevice != null)
            Column(
              children: [
                Text("Connected to ${connectedDevice!.remoteId}"),
                ElevatedButton(
                  onPressed: () async {
                    await connectedDevice!.disconnect();
                    setState(() {
                      connectedDevice = null;
                      services.clear();
                    });
                  },
                  child: Text('Disconnect'),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                bool isScanning = await FlutterBluePlus.isScanning.first;
                if (isScanning) {
                  FlutterBluePlus.stopScan();
                  print("Scan stopped by user.");
                } else {
                  startScan();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Scan',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
