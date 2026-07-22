import 'dart:convert';
import 'package:app/features/book/presentation/screen/book_content_screen.dart';
import 'package:app/features/book/presentation/screen/book_screen.dart';
import 'package:app/features/subscriptions/providers/subscription_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

// 1. Android Notification Channels
const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'General Notifications',
  description: 'Default notification channel for general announcements.',
  importance: Importance.high,
);

const AndroidNotificationChannel updatesChannel = AndroidNotificationChannel(
  'updates_channel',
  'App Updates & News',
  description: 'Notifications for new book releases, features, and content updates.',
  importance: Importance.high,
);

const AndroidNotificationChannel marketingChannel = AndroidNotificationChannel(
  'marketing_channel',
  'Offers & Promotions',
  description: 'Special offers, subscription discounts, and promotional updates.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // 1. Request Notification Permissions (Required for Android 13+ & iOS)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('FCM Authorization Status: ${settings.authorizationStatus}');

      // 2. Create All 3 Android Notification Channels Natively
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(highImportanceChannel);
        await androidPlugin.createNotificationChannel(updatesChannel);
        await androidPlugin.createNotificationChannel(marketingChannel);
      }

      // 3. Initialize Local Notifications Plugin
      const AndroidInitializationSettings initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const InitializationSettings initSettings = InitializationSettings(
        android: initSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Local notification tapped with payload: ${response.payload}');
          if (response.payload != null && response.payload!.isNotEmpty) {
            try {
              final Map<String, dynamic> data = jsonDecode(response.payload!);
              _handleNotificationRoutingData(data);
            } catch (e) {
              debugPrint('Error parsing notification payload: $e');
            }
          }
        },
      );

      // 4. Set Foreground Notification Presentation Options
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Get FCM Device Token for testing
      String? token = await _fcm.getToken();
      debugPrint('📲 FCM Device Token: $token');

      // 6. Subscribe to FCM Topics ('all_users', 'updates', 'marketing')
      await _fcm.subscribeToTopic('all_users');
      await _fcm.subscribeToTopic('updates');
      await _fcm.subscribeToTopic('marketing');
      debugPrint('Subscribed to FCM topics: all_users, updates, marketing');

      // 7. Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token Refreshed: $newToken');
      });

      // 8. Handle Messages in Foreground (Show Notification Banner with dynamic channel)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received Foreground Message: ${message.notification?.title} - ${message.notification?.body}');
        
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          // Resolve target channel
          String channelId = android.channelId ?? 'high_importance_channel';
          if (message.data['channel'] == 'marketing' || message.data['screen_target'] == 'paywall') {
            channelId = 'marketing_channel';
          } else if (message.data['channel'] == 'updates') {
            channelId = 'updates_channel';
          }

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId,
                channelId == 'marketing_channel'
                    ? 'Offers & Promotions'
                    : channelId == 'updates_channel'
                        ? 'App Updates & News'
                        : 'General Notifications',
                icon: '@mipmap/launcher_icon',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      });

      // 9. Handle Notification Click when App is in Background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('App opened from background notification tap: ${message.notification?.title}');
        _handleNotificationRouting(message);
      });

      // 10. Handle Notification Click when App was Terminated
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('App opened from terminated state notification tap: ${initialMessage.notification?.title}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNotificationRouting(initialMessage);
        });
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  void _handleNotificationRouting(RemoteMessage message) {
    _handleNotificationRoutingData(message.data);
  }

  void _handleNotificationRoutingData(Map<String, dynamic> data) {
    debugPrint("Processing notification tap payload data: $data");

    // Extract target screen or channel
    final String target = (data['screen_target'] ?? data['screen'] ?? data['target'] ?? '').toString();
    final String channel = (data['channel'] ?? '').toString();

    // 🚀 Marketing / Paywall trigger: Open RevenueCat Paywall
    if (target == 'paywall' || channel == 'marketing' || channel == 'marketing_channel') {
      _showPaywall();
      return;
    }

    final navState = navigatorKey.currentState;
    if (navState == null) {
      debugPrint("Navigator state is null, cannot route notification.");
      return;
    }

    switch (target) {
      case 'paywall':
        _showPaywall();
        break;

      case 'home':
        // Force navigation back to home dashboard
        navState.popUntil((route) => route.isFirst);
        break;

      case 'book_details':
      case 'book':
        final String? bookId = data['book_id'] ?? data['bookId'] ?? data['id'];
        if (bookId != null && bookId.isNotEmpty) {
          navState.push(
            MaterialPageRoute(
              builder: (_) => BookPage(bookId: bookId),
            ),
          );
        }
        break;

      case 'book_content':
      case 'content':
        final String? contentId = data['content_id'] ?? data['contentId'];
        if (contentId != null && contentId.isNotEmpty) {
          navState.push(
            MaterialPageRoute(
              builder: (_) => BookContentPage(contentId: contentId),
            ),
          );
        }
        break;

      default:
        // Smart fallback: if book_id / bookId exists in payload, open book details page
        final String? fallbackBookId = data['book_id'] ?? data['bookId'] ?? data['id'];
        final String? fallbackContentId = data['content_id'] ?? data['contentId'];

        if (fallbackBookId != null && fallbackBookId.isNotEmpty) {
          navState.push(
            MaterialPageRoute(
              builder: (_) => BookPage(bookId: fallbackBookId),
            ),
          );
        } else if (fallbackContentId != null && fallbackContentId.isNotEmpty) {
          navState.push(
            MaterialPageRoute(
              builder: (_) => BookContentPage(contentId: fallbackContentId),
            ),
          );
        } else {
          debugPrint("No specific screen target specified. Opening app normally.");
        }
        break;
    }
  }

  void _showPaywall() async {
    try {
      debugPrint("🚀 Fetching RevenueCat offerings for paywall notification tap...");
      final Offerings offerings = await Purchases.getOfferings();

      if (offerings.all["yearly_offer"] != null) {
        await RevenueCatUI.presentPaywall(
          displayCloseButton: true,
          offering: offerings.all["yearly_offer"]!,
        );
      } else if (offerings.current != null) {
        await RevenueCatUI.presentPaywall(
          displayCloseButton: true,
          offering: offerings.current!,
        );
      } else {
        await RevenueCatUI.presentPaywall(displayCloseButton: true);
      }
    } catch (e) {
      debugPrint("Error presenting Paywall: $e");
    }
  }
}
