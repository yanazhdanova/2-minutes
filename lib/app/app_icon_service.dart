import 'package:flutter/services.dart';

enum AppIconVariant { main, alt }

class AppIconService {
  AppIconService._();

  static const _channel = MethodChannel('two_mins/app_icon');

  static Future<void> setIcon(AppIconVariant variant) {
    return _channel.invokeMethod<void>('setIcon', _variantToString(variant));
  }

  static Future<AppIconVariant> getIcon() async {
    final value = await _channel.invokeMethod<String>('getIcon');
    return _variantFromString(value);
  }

  static String _variantToString(AppIconVariant variant) => switch (variant) {
    AppIconVariant.alt => 'alt',
    AppIconVariant.main => 'main',
  };

  static AppIconVariant _variantFromString(String? value) =>
      value == 'alt' ? AppIconVariant.alt : AppIconVariant.main;
}
