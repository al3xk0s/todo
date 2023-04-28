import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformType {
  const PlatformType._();

  static const ios = PlatformType._();
  static const android = PlatformType._();

  static const windows = PlatformType._();
  static const mac = PlatformType._();
  static const linux = PlatformType._();

  static const web = PlatformType._();

  static const unknown = PlatformType._();

  static const values = [
    android,
    ios,
    web,
    windows,
    linux,
    mac,
    unknown,
  ];

  static PlatformType get current => _current ?? PlatformType.detect();

  static PlatformType? _current;

  factory PlatformType.detect() {
    if(Platform.isAndroid) return android;
    if(Platform.isIOS) return ios;
    if(kIsWeb) return web;

    if(Platform.isWindows) return windows;
    if(Platform.isLinux) return linux;
    if(Platform.isMacOS) return mac;

    return unknown;
  }
}