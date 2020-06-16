
  import 'package:permission_handler/permission_handler.dart';  

class permission_class{
   void  requestPermission() async {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.microphone);

      if (permission != PermissionStatus.granted) {
        await PermissionHandler()
            .requestPermissions([PermissionGroup.microphone]);
      }
  } 
}
