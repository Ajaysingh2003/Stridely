import 'dart:async';
import 'package:app/features/subscriptions/service/init.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'revenue_cat_service.dart';

// ─── RAW CUSTOMER INFO STREAM ───────────────────────────────────────────────
// Single source of truth. Wraps RevenueCat's listener in a Dart Stream so
// Riverpod manages the listener lifecycle for us (auto-cleanup on dispose).
final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
  final controller = StreamController<CustomerInfo>.broadcast();

  void listener(CustomerInfo info) => controller.add(info);

  // Seed the stream with current state immediately, so consumers don't
  // wait for the first store event to know initial status.
  Purchases.getCustomerInfo().then((info) {
    if (!controller.isClosed) controller.add(info);
  }).catchError((e) {
    if (!controller.isClosed) controller.addError(e);
  });

  Purchases.addCustomerInfoUpdateListener(listener);

  ref.onDispose(() {
    Purchases.removeCustomerInfoUpdateListener(listener);
    controller.close();
  });

  return controller.stream;
});

// ─── DERIVED PREMIUM STATUS ──────────────────────────────────────────────
// What your UI actually watches. Defaults to false while loading or on error
// so gated content stays locked until proven otherwise.
final isPremiumProvider = Provider<bool>((ref) {
  final asyncInfo = ref.watch(customerInfoProvider);
  return asyncInfo.when(
    data: (info) =>
        info.entitlements.all[RevenueCatService.premiumEntitlementId]?.isActive ??
        false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// ─── PURCHASE / RESTORE ACTIONS ──────────────────────────────────────────
// Actions live separately from status. They don't hold their own bool state —
// customerInfoProvider updates automatically once a purchase/restore
// succeeds, since RevenueCat's listener fires and the stream above picks it up.
final subscriptionActionsProvider =
    Provider<SubscriptionActions>((ref) => SubscriptionActions());

class SubscriptionActions {
  Future<PurchaseResult> purchase(Package package) async {
    final success = await RevenueCatService.instance.purchasePackage(package);
    return success ? PurchaseResult.success : PurchaseResult.failed;
  }

  Future<bool> restore() {
    return RevenueCatService.instance.restorePurchases();
  }

  Future<Offerings?> fetchOfferings() {
    return RevenueCatService.instance.fetchCurrentOfferings();
  }
}

enum PurchaseResult { success, failed, cancelled }