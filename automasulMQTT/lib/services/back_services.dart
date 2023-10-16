import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

// Função para inicializar o serviço em segundo plano
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

// Função que é chamada quando o aplicativo está em segundo plano no iOS
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

// Função que é chamada quando o serviço é iniciado (tanto no iOS quanto no Android)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  
  if (service is AndroidServiceInstance) {
    // Configura os eventos para definir o serviço como em primeiro plano ou em segundo plano no Android
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  
  // Configura o evento para parar o serviço
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  
  // Executa uma tarefa periódica a cada 5 segundos
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      // Verifica se o serviço está em primeiro plano no Android
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "Monitoramento", content: "em tempo real");
      }
    } 
    // Invoca um método chamado 'update'
    service.invoke('update'); 
  });
}


