import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class WindowsNotification {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  static Future<void> initializeNotification() async {
    final InitializationSettings settings = InitializationSettings(
      windows: WindowsInitializationSettings(
        iconPath: 'Assets/skylo.png',
        appName: 'shylo',
        appUserModelId: 'CompanyName.ProductName.SubProduct.VersionInformation',
        guid: '550e8400-e29b-41d4-a716-446655440000',
      ),
    );
   await  _notification.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (response){
      },
      onDidReceiveNotificationResponse: (receivedNotification) {      
      },
    );
  }
    // lets show the notification herer
static Future<void>showNotification({required String title , required String body})async{
  int id = Random().nextInt(20);
  await _notification.show(id, title, body, NotificationDetails(
    windows: WindowsNotificationDetails(
      
    )
  ));
}
}
