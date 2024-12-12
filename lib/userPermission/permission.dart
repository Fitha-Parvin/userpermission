import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: permision(),
  ));
}

class permision extends StatelessWidget {
  const permision({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 350),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    requestCameraPermission();
                  },
                  child: Text(
                    "Go",
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  onPressed: () {
                    requestMultiplePermission();
                  },
                  child: Text("Go", style: TextStyle(fontSize: 20))),
              ElevatedButton(
                  onPressed: () {
                    requestPermissionWithOpenSettings();
                  },
                  child: Text("Go", style: TextStyle(fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }

  void requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      print("permission Grantsed");
    } else {
      if (await Permission.camera.request().isGranted) {
        print("permission was granted");
      }
    }
  }

  void requestMultiplePermission() async {
    Map<Permission, PermissionStatus> statues = await [
      Permission.location,
      Permission.storage,
      Permission.phone
    ].request();
    print("location permission:${statues[Permission.location]},"
        "storage permission:${statues[Permission.storage]}");
  }

  void requestPermissionWithOpenSettings() async {
    openAppSettings();
  }
}
