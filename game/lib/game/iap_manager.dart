import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPManager extends ChangeNotifier {
  static const String _adRemovedKey = 'ads_removed';
  bool _isAdRemoved = false;

  bool get isAdRemoved => _isAdRemoved;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdRemoved = prefs.getBool(_adRemovedKey) ?? false;
    notifyListeners();
  }

  Future<bool> purchaseProduct(String productId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate generic success just for mock
    // In real app, check productId and connect to store
    return true;
  }

  Future<void> removeAds() async {
    _isAdRemoved = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adRemovedKey, true);
    notifyListeners();
  }
}
