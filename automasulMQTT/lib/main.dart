import 'package:flutter/material.dart';
import 'package:notificacaonovamenteteste/services/back_services.dart';
import 'package:notificacaonovamenteteste/mqtt/state/MQTTAppState.dart';
import 'package:notificacaonovamenteteste/services/notification_service.dart';
import 'package:notificacaonovamenteteste/widgets/mqttView.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await initializeService();
  runApp(MultiProvider(
    providers: [
      Provider<NotificationService>(
        create: (context) => NotificationService(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: const MQTTView(),
        ));
  }
}
