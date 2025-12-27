import 'package:local_notifier/local_notifier.dart';

class LocalNotificationController {
  static Future<void> initializeNotification() async {
    await LocalNotifier.instance.setup(
      appName: 'shylo',
      shortcutPolicy: ShortcutPolicy.requireCreate,

    );
  }

  static Future<void> showNotification({required String title , required String body})async{
    final LocalNotification localNotification = LocalNotification(title: title , body:body);
    await localNotification.show();
    //handle local notification on click
    localNotification.onClick = (){};
    // handle local notification 
    localNotification.onClose = (res){

    };
  }
}
