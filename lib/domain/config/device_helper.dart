import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceResult {
  String name;
  String code;

  DeviceResult(this.name, this.code);
}

final class DeviceHelper {
  static Future<DeviceResult> getDevice() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    late String name;
    late String code;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      name = androidInfo.model;
      code = androidInfo.id;

      if (kDebugMode) {
        print('Running on ${androidInfo.model}');
      }
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      name = iosInfo.name!;
      code = iosInfo.identifierForVendor!;

      if (kDebugMode) {
        print('Running on ${iosInfo.utsname.machine}');
      }
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await _deviceInfo.linuxInfo;
      name = linuxInfo.name;
      code = linuxInfo.machineId!;

      if (kDebugMode) {
        print('Running on ${linuxInfo.name}');
      }
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await _deviceInfo.macOsInfo;
      name = macOsInfo.computerName;
      code = macOsInfo.systemGUID!;

      if (kDebugMode) {
        print('Running on ${macOsInfo.computerName}');
      }
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await _deviceInfo.windowsInfo;
      name = windowsInfo.computerName;
      code = windowsInfo.deviceId;

      if (kDebugMode) {
        print('Running on ${windowsInfo.computerName}');
      }
    }

    return DeviceResult(name, code);
  }

  static String formatDeviceName(String name) {
    String result = '';
    if (name.isEmpty) {
      throw Error();
    } else if (name.length == 16 || name.length < 16) {
      result = name;
    } else if (name.length > 16) {
      result = name.substring(0, 16);
    }
    return result;
  }
}
