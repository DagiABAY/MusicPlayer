import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
class Permissions {

static Future<void>  requestPermissions(BuildContext context) async {
  var status = await Permission.storage.request();

  if (status.isGranted) {
    print("Storage permission granted.");
  } else if (status.isDenied) {
    print("Storage permission denied.");
    _showPermissionDeniedDialog(context);
  } else if (status.isPermanentlyDenied) {
    print("Storage permission permanently denied.");
    openAppSettings();
  }
}

static void  _showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Permission Denied"),
        content:
            Text("This app needs storage permission to function properly."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


}