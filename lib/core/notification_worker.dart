import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

const waterReminderTask = "waterReminderTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == waterReminderTask) {
      final now = DateTime.now();
      if (now.weekday == DateTime.monday && now.hour == 21 && now.minute < 15) {
        await NotificationService.init();
        await NotificationService.showNotification();
      }
      // if (now.minute < 60) {
      //   await NotificationService.showNotification();
      // }
    }

    return Future.value(true);
  });
}
