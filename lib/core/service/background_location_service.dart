import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../../firebase_options.dart';

class BackgroundLocationService {
  static const String notificationChannelId = 'beepbeep_location_channel';

  static const int notificationId = 888;

  static Future<void> initialize() async {
    final service = FlutterBackgroundService();

    // Create notification channel
    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await notifications.initialize(settings: initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'BeepBeep Location Tracking',
      description: 'Notifications for active driver location tracking.',
      importance: Importance.low,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Configure background service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,

        notificationChannelId: notificationChannelId,

        initialNotificationTitle: 'BeepBeep Tracking',
        initialNotificationContent: 'Live location sharing is active',

        foregroundServiceNotificationId: notificationId,
      ),

      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  // START
  static Future<void> start() async {
    final service = FlutterBackgroundService();

    final isRunning = await service.isRunning();

    if (!isRunning) {
      await service.startService();
    }
  }


  // STOP
  static Future<void> stop() async {
    final service = FlutterBackgroundService();

    final isRunning = await service.isRunning();

    if (isRunning) {
      service.invoke('stopService');
    }
  }

 
  // CHECK STATUS
  static Future<bool> isRunning() async {
    return FlutterBackgroundService().isRunning();
  }
}


// BACKGROUND ENTRY POINT
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  
  // Android foreground service
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.setAsForegroundService();
  }

  
  // Location subscription
  StreamSubscription<Position>? locationSubscription;


  // Stop service listener
  service.on('stopService').listen((event) async {
    await locationSubscription?.cancel();

    locationSubscription = null;

    service.stopSelf();
  });

  
  // Get authenticated driver
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    service.stopSelf();
    return;
  }

  final String uid = user.uid;

  
  // Location settings
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 5,
  );

  
  // Start location stream
  locationSubscription =
      Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position position) async {
          try {
            await FirebaseFirestore.instance
                .collection('driver_profiles')
                .doc(uid)
                .update({
                  'latitude': position.latitude,
                  'longitude': position.longitude,
                  'lastUpdated': FieldValue.serverTimestamp(),
                });

            // Update foreground notification.
            if (service is AndroidServiceInstance) {
              service.setForegroundNotificationInfo(
                title: 'BeepBeep Tracking',
                content:
                    'Live location active • '
                    '${position.latitude.toStringAsFixed(5)}, '
                    '${position.longitude.toStringAsFixed(5)}',
              );
            }

            debugPrint(
              'Background location: '
              '${position.latitude}, ${position.longitude}',
            );
          } catch (e) {
            debugPrint('Background location update failed: $e');
          }
        },
        onError: (error) {
          debugPrint('Background location stream error: $error');
        },
      );
}


// iOS BACKGROUND ENTRY POINT
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  return true;
}
