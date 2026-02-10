import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _firstRun = 'firstRun';
  static const _accessToken = 'accessToken';
  static const _customServerUrl = 'customServerUrl';

  late final SharedPreferencesAsync _sharedPreference;

  SharedPreferencesHelper._() {
    _sharedPreference = SharedPreferencesAsync();
  }

  static final SharedPreferencesHelper _shared = SharedPreferencesHelper._();

  factory SharedPreferencesHelper() => _shared;

  Future<void> setFirstRun(bool value) async {
    return _sharedPreference.setBool(_firstRun, value);
  }

  Future<bool?> get isFirstRun => _sharedPreference.getBool(_firstRun);

  Future<void> setAccessToken(String value) async {
    AndroidOptions _getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    IOSOptions _getIosOptions() =>
        const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    final storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    await storage.write(key: _accessToken, value: value);
  }

  Future<String?> get accessToken {
    AndroidOptions _getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    IOSOptions _getIosOptions() =>
        const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    final storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    return storage.read(key: _accessToken);
  }

  Future<void> removeAccessToken() async {
    AndroidOptions _getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    IOSOptions _getIosOptions() =>
        const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    final storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
    return storage.delete(key: _accessToken);
  }

  Future<void> setCustomServerUrl(String value) async {
    return _sharedPreference.setString(_customServerUrl, value);
  }

  Future<String?> get customServerUrl =>
      _sharedPreference.getString(_customServerUrl);

  Future<void> removeCustomServerUrl() async {
    return _sharedPreference.remove(_customServerUrl);
  }

  void dispose() {}
}
