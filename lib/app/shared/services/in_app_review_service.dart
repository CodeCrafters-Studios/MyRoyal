import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:in_app_review/in_app_review.dart';

class InAppReviewService {
  static final InAppReviewService _instance = InAppReviewService._internal();

  factory InAppReviewService() {
    return _instance;
  }

  InAppReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

  Future<bool> isAvailable() async {
    return await _inAppReview.isAvailable();
  }

  Future<void> requestReview() async {
    try {
      await _inAppReview.requestReview();
    } catch (e) {
      AppUtils.logApp('Error requesting review: $e');
    }
  }

  /// Open the app store listing page
  /// Android: Opens Google Play Store
  /// iOS: Opens App Store
  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(
        appStoreId: 'YOUR_IOS_APP_ID',
        microsoftStoreId: '',
      );
    } catch (e) {
      AppUtils.logApp('Error opening store listing: $e');
    }
  }

  /// Request review with custom parameters
  Future<void> requestReviewIfEligible({
    required int minAppUsageCount,
    int currentUsageCount = 0,
  }) async {
    try {
      if (currentUsageCount >= minAppUsageCount && await isAvailable()) {
        await requestReview();
      }
    } catch (e) {
      AppUtils.logApp('Error in conditional review request: $e');
    }
  }

  /// Increments the app usage count (stored as a string in AppStorage)
  Future<int> incrementUsageCount(AppStorage appStorage) async {
    try {
      final currentStr = await appStorage.read(CACHE_APP_USAGE_COUNT);
      final currentCount =
          currentStr != null ? int.tryParse(currentStr) ?? 0 : 0;
      final newCount = currentCount + 1;
      await appStorage.write(CACHE_APP_USAGE_COUNT, newCount.toString());
      AppUtils.logApp('App usage count incremented to: $newCount');
      return newCount;
    } catch (e) {
      AppUtils.logApp('Error incrementing usage count: $e');
      return 0;
    }
  }

  /// Returns current usage count
  Future<int> getUsageCount(AppStorage appStorage) async {
    try {
      final currentStr = await appStorage.read(CACHE_APP_USAGE_COUNT);
      return currentStr != null ? int.tryParse(currentStr) ?? 0 : 0;
    } catch (e) {
      AppUtils.logApp('Error reading usage count: $e');
      return 0;
    }
  }

  /// Checks if review should be requested based on usage count
  Future<void> checkAndTriggerUsageReview(AppStorage appStorage,
      {int minAppUsageCount = 5}) async {
    try {
      final alreadyReviewed =
          await appStorage.read(CACHE_HAS_REQUESTED_REVIEW) == 'true';
      if (alreadyReviewed) {
        AppUtils.logApp(
            'In-App Review has already been requested once based on usage count.');
        return;
      }

      final count = await getUsageCount(appStorage);
      if (count >= minAppUsageCount) {
        AppUtils.logApp(
            'Usage count ($count) reached minimum limit ($minAppUsageCount). Requesting review...');
        if (await isAvailable()) {
          await requestReview();
          await appStorage.write(CACHE_HAS_REQUESTED_REVIEW, 'true');
        }
      }
    } catch (e) {
      AppUtils.logApp('Error in checkAndTriggerUsageReview: $e');
    }
  }

  Future<void> trackApiHitAndCheckReview(AppStorage appStorage,
      {int minAppUsageCount = 5}) async {
    try {
      // Increment the usage count
      final newCount = await incrementUsageCount(appStorage);
      AppUtils.logApp('[API HIT] Usage count: $newCount/$minAppUsageCount');

      // Check if we should trigger review
      await checkAndTriggerUsageReview(appStorage,
          minAppUsageCount: minAppUsageCount);
    } catch (e) {
      AppUtils.logApp('Error in trackApiHitAndCheckReview: $e');
    }
  }
}
