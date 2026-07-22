// import 'dart:async';
// import 'dart:io' show Platform;
// import 'package:app/features/auth/domain/entities/user_entity.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class RevenueCatService {
//   RevenueCatService._privateConstructor();
//   static final RevenueCatService instance =
//       RevenueCatService._privateConstructor();
//   static const String premiumEntitlementId = 'premium_access';

//   Future<void> loginUser(UserEntity user) async {
//     try {
//       await Purchases.logIn(user.uid);

//       await Purchases.setEmail(user.email ?? "");
//       await Purchases.setFirebaseAppInstanceId(user.uid);
//       if (user.name != null) {
//         await Purchases.setDisplayName(user.name!);
//       }
//     } catch (e) {
//       
//     }
//   }

//   Future<void> logoutUser() async {
//     try {
//       await Purchases.logOut();
//     } catch (e) {
//       
//     }
//   }

//   // ─── INITIALIZE REVENUECAT SDK ─────────────────────────────────────────────
//   Future<void> init() async {
//     // Enable debug logging during development cycles to inspect store callbacks
//     await Purchases.setLogLevel(LogLevel.debug);

//     PurchasesConfiguration configuration;

//     if (kIsWeb) {
//       configuration = PurchasesConfiguration(
//         "test_wRjqVJSmIWgtGrVFPbxaMpgKthL",
//       );
//     } else if (Platform.isAndroid) {
//       configuration = PurchasesConfiguration(
//          "test_wRjqVJSmIWgtGrVFPbxaMpgKthL",
//         // "goog_pOQLjKWlvvgMJVQOJoZetRHoSQQ",
//       );
//     } else if (Platform.isIOS) {
//       configuration = PurchasesConfiguration(
//         "test_wRjqVJSmIWgtGrVFPbxaMpgKthL",
//       );
//     } else {
//       return; // Unsupported platform fallback target
//     }

//     // Optional: Pass your internal application database UID to link purchases explicitly
//     // configuration.appUserID = "user_internal_database_uid";

//     await Purchases.configure(configuration);
//   }

//   // ─── CHECK ACTIVE PREMIUM ENTITLEMENTS ──────────────────────────────────────
//   Future<bool> isUserPremium() async {
//     try {
//       final customerInfo = await Purchases.getCustomerInfo();
//       // 'premium_access' maps to your named Entitlement ID configured on the RevenueCat Dashboard
//       return customerInfo.entitlements.all[premiumEntitlementId]?.isActive ??
//           false;
//     } catch (e) {
//       return false;
//     }
//   }

//   // ─── FETCH PAYWALL REVENUECAT OFFERINGS ──────────────────────────────────────
//   Future<Offerings?> fetchCurrentOfferings() async {
//     try {
//       return await Purchases.getOfferings();
//     } on PlatformException catch (e) {
//       
//       return null;
//     }
//   }

//   // ─── TRIGGER AN ATOMIC PURCHASE TRANSACTION ─────────────────────────────────
//   Future<bool> purchasePackage(Package package) async {
//     try {
//       // 1. Capture the PurchaseResult wrapper
//       final PurchaseResult result = await Purchases.purchasePackage(package);

//       // 2. 💡 THE FIX: Extract customerInfo out of the result wrapper first!
//       final CustomerInfo customerInfo = result.customerInfo;

//       // 3. Now you can safely inspect your entitlement state fields
//       return customerInfo.entitlements.all['premium_access']?.isActive ?? false;
//     } on PlatformException catch (e) {
//       final errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
//         
//       }
//       return false;
//     }
//   }

//   // ─── RESTORE EXSTING ACCOUNT SUBSCRIPTIONS ──────────────────────────────────
//   Future<bool> restorePurchases() async {
//     try {
//       final customerInfo = await Purchases.restorePurchases();
//       return customerInfo.entitlements.all['premium_access']?.isActive ?? false;
//     } catch (e) {
//       return false;
//     }
//   }
// }
// // ─── SINGLETON REAL-TIME RAW STREAM ──────────────────────────────────────────
// late final Stream<CustomerInfo> customerInfoStream = _initCustomerInfoStream();

// Stream<CustomerInfo> _initCustomerInfoStream() {
//   final controller = StreamController<CustomerInfo>.broadcast();
  
//   // Immediately seed the stream with current cached data so the UI doesn't look blank on boot
//   Purchases.getCustomerInfo().then((info) {
//     if (!controller.isClosed) controller.add(info);
//   }).catchError((_) {});

//   // Listen for real-time webhooks/updates from RevenueCat servers
//   Purchases.addCustomerInfoUpdateListener((info) {
//     if (!controller.isClosed) controller.add(info);
//   });

//   return controller.stream;
// }



import 'dart:io' show Platform;
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum PurchaseResult { success, failed, cancelled }

enum RestoreResult { restored, nothingToRestore, failed }

class RevenueCatService {
  RevenueCatService._privateConstructor();
  static final RevenueCatService instance =
      RevenueCatService._privateConstructor();
  static const String premiumEntitlementId = 'premium_access';

  // Debug/sandbox key — safe to keep hardcoded since it's test-only.
  static const String _testKey = "test_wRjqVJSmIWgtGrVFPbxaMpgKthL";

  // Production keys — RevenueCat issues one per platform since each
  // talks to a different store's billing backend. Replace with your
  // real dashboard values before release.
  static const String _androidKey = "goog_pOQLjKWlvvgMJVQOJoZetRHoSQQ";
  static const String _iosKey = "appl_YOUR_IOS_KEY_HERE"; // TODO: real iOS key

  Future<void> loginUser(UserEntity user) async {
    try {
      await Purchases.logIn(user.uid);
      await Purchases.setEmail(user.email ?? "");
      if (user.name != null) {
        await Purchases.setDisplayName(user.name!);
      }
      // Firebase Analytics App Instance ID (NOT the Firebase Auth UID) —
      // wire this up separately if you use Firebase Analytics attribution:
      //
      // final instanceId = await FirebaseAnalytics.instance.appInstanceId;
      // if (instanceId != null) {
      //   await Purchases.setFirebaseAppInstanceId(instanceId);
      // }
    } catch (e) {
      _log('RevenueCat login failed: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      _log('RevenueCat logout failed: $e');
    }
  }

  // ─── INITIALIZE REVENUECAT SDK ─────────────────────────────────────────
  Future<void> init() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

    PurchasesConfiguration configuration;

    if (kIsWeb) {
      configuration = PurchasesConfiguration(_testKey);
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(
        kDebugMode ? _testKey : _androidKey,
      );
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(
        kDebugMode ? _testKey : _iosKey,
      );
    } else {
      return; // Unsupported platform
    }

    await Purchases.configure(configuration);
  }

  // ─── CHECK ACTIVE PREMIUM ENTITLEMENT ───────────────────────────────────
  Future<bool> isUserPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[premiumEntitlementId]?.isActive ??
          false;
    } catch (e) {
      _log('isUserPremium check failed: $e');
      return false;
    }
  }

  // ─── FETCH PAYWALL OFFERINGS ─────────────────────────────────────────────
  Future<Offerings?> fetchCurrentOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      _log('Failed to fetch offerings: ${e.message}');
      return null;
    }
  }

  // ─── TRIGGER A PURCHASE ──────────────────────────────────────────────────
  Future<PurchaseResult> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      final isPremium =
          result.customerInfo.entitlements.all[premiumEntitlementId]
                  ?.isActive ??
              false;
      return isPremium ? PurchaseResult.success : PurchaseResult.failed;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled;
      }
      _log('Purchase failed: ${e.message}');
      return PurchaseResult.failed;
    }
  }

  // ─── RESTORE EXISTING PURCHASES ──────────────────────────────────────────
  Future<RestoreResult> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      final isPremium =
          customerInfo.entitlements.all[premiumEntitlementId]?.isActive ??
              false;
      return isPremium
          ? RestoreResult.restored
          : RestoreResult.nothingToRestore;
    } catch (e) {
      _log('Restore purchases failed: $e');
      return RestoreResult.failed;
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      
    }
  }
}