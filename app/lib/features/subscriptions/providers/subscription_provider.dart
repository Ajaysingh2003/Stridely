// import 'dart:async';
// import 'package:app/features/subscriptions/service/init.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// // ─── RAW CUSTOMER INFO STREAM ───────────────────────────────────────────────
// final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
//   final controller = StreamController<CustomerInfo>.broadcast();

//   // 1. Keep a local reference to the exact listener closure
//   final CustomerInfoUpdateListener listener = (CustomerInfo info) {
//     if (!controller.isClosed) controller.add(info);
//   };

//   Purchases.getCustomerInfo().then((info) {
//     if (!controller.isClosed) controller.add(info);
//   }).catchError((e) {
//     if (!controller.isClosed) controller.addError(e);
//   });

//   Purchases.addCustomerInfoUpdateListener(listener);

//   // 🎯 FIX 1: Clean up the listener instance cleanly to prevent memory leaks
//   ref.onDispose(() {
//     Purchases.removeCustomerInfoUpdateListener(listener);
//     controller.close();
//   });

//   return controller.stream;
// });

// final isPremiumProvider = Provider<bool>((ref) {
//   final asyncInfo = ref.watch(customerInfoProvider);
//   return asyncInfo.when(
//     data: (info) =>
//         info.entitlements.all[RevenueCatService.premiumEntitlementId]?.isActive ??
//         false,
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

// // ─── PURCHASE / RESTORE ACTIONS ──────────────────────────────────────────
// final subscriptionActionsProvider =
//     Provider<SubscriptionActions>((ref) => SubscriptionActions());

// class SubscriptionActions {
//   // 🎯 FIX 2: Fixed signature mismatch & added clean mapping for the 'cancelled' state
//   Future<PurchaseResult> purchase(Package package) async {
//     try {
//       // Direct assignment uses your existing service class layout
//       final bool isPremium = await RevenueCatService.instance.purchasePackage(package);
//       return isPremium ? PurchaseResult.success : PurchaseResult.failed;
//     } catch (e) {
//       // Catch native cancel exceptions gracefully if passed up from the SDK layer
//       return PurchaseResult.cancelled;
//     }
//   }

//   Future<bool> restore() {
//     return RevenueCatService.instance.restorePurchases();
//   }

//   Future<Offerings?> fetchOfferings() {
//     return RevenueCatService.instance.fetchCurrentOfferings();
//   }
// }

// enum PurchaseResult { success, failed, cancelled }

import 'dart:async';
import 'package:app/features/subscriptions/service/init.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ─── RAW CUSTOMER INFO STREAM ───────────────────────────────────────────
// Single source of truth for customer info — listener is stored and
// cleaned up on dispose, avoiding the duplicate/leaking listener that
// existed as a top-level `late final` stream in the old service file.

final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
  final controller = StreamController<CustomerInfo>.broadcast();

  final CustomerInfoUpdateListener listener = (CustomerInfo info) {
    if (!controller.isClosed) controller.add(info);
  };

  Purchases.getCustomerInfo()
      .then((info) {
        if (!controller.isClosed) controller.add(info);
      })
      .catchError((e) {
        if (!controller.isClosed) controller.addError(e);
      });

  Purchases.addCustomerInfoUpdateListener(listener);

  ref.onDispose(() {
    Purchases.removeCustomerInfoUpdateListener(listener);
    controller.close();
  });

  return controller.stream;
});

final isPremiumProvider = Provider<bool>((ref) {
  final asyncInfo = ref.watch(customerInfoProvider);

  return asyncInfo.when(
    data: (info) =>
        info
            .entitlements
            .all[RevenueCatService.premiumEntitlementId]
            ?.isActive ??
        false,
    loading: () => false,
    error: (error, stackTrace) {
      // 👈 You can read, print, or report the error directly here
      debugPrint("❌ RevenueCat CustomerInfo Error: $error");
      debugPrint("💥 StackTrace: $stackTrace");

      return false; // Still defaults to false for the UI
    },
  );
});

// ─── PURCHASE / RESTORE ACTIONS ──────────────────────────────────────────
final subscriptionActionsProvider = Provider<SubscriptionActions>(
  (ref) => SubscriptionActions(),
);

class SubscriptionActions {
  // PurchaseResult now comes straight from the service, already correctly
  // distinguishing success / failed / cancelled — no re-mapping needed here.
  Future purchase(Package package) {
    return RevenueCatService.instance.purchasePackage(package);
  }

  Future<RestoreResult> restore() {
    return RevenueCatService.instance.restorePurchases();
  }

  Future<Offerings?> fetchOfferings() {
    return RevenueCatService.instance.fetchCurrentOfferings();
  }
}
