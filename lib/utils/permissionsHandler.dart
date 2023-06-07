import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }
}