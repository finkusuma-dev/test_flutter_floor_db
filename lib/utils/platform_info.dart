import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;


class PlatformInfo {

  static bool isDesktopOS() {

    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  }


  static bool isAppOS() {

    return Platform.isIOS || Platform.isAndroid;

  }


  static bool isWeb() {

    return kIsWeb;

  }


  static PlatformType getCurrentPlatformType() {

    if (kIsWeb) {

      return PlatformType.web;

    }


    if (Platform.isMacOS) {

      return PlatformType.macOS;

    }


    if (Platform.isFuchsia) {

      return PlatformType.fuchsia;

    }


    if (Platform.isLinux) {

      return PlatformType.linux;

    }


    if (Platform.isWindows) {

      return PlatformType.windows;

    }


    if (Platform.isIOS) {

      return PlatformType.iOS;

    }


    if (Platform.isAndroid) {

      return PlatformType.android;

    }


    return PlatformType.unknown;

  }

}


enum PlatformType {

  web,

  iOS,

  android,

  macOS,

  fuchsia,

  linux,

  windows,

  unknown

}