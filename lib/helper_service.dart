import 'dart:io';

import 'package:automates_integration_package/all_code.dart';
import 'package:flutter/material.dart';

import 'global_variable.dart';
import 'main.dart';

class HelperService {
  bool checkIsDone({
    required List<AllState> dependentState,
    required AllState currentState,
  }) {
    bool done = false;
    int myIndex = stateSequence.indexWhere((e) => e == dependentState.first);
    int currentIndex = stateSequence.indexWhere((e) => e == currentState);
    if (myIndex < currentIndex) {
      done = true;
    }
    return done;
  }

  bool checkIsLoading({
    required List<AllState> dependentState,
    required AllState currentState,
  }) {
    return ((currentState == AllState.selectingFlutterProject ||
            currentState == AllState.addingPackage ||
            currentState == AllState.addingPubGet ||
            currentState == AllState.addingApiKey ||
            currentState == AllState.addingAndroidConfig ||
            currentState == AllState.addingIosConfig ||
            currentState == AllState.addingMapWidget) &&
        dependentState.contains(currentState));
  }

  Future<bool> checkIsItFlutterProject(String directoryPath) async {
    final pubspec = File('$directoryPath/pubspec.yaml');
    return await pubspec.exists();
  }

  Future<bool> addPackage({
    required String projectDirectory,
    required String packageName,
  }) async {
    try {
      await Process.run(
        'flutter',
        ['pub', 'add', packageName],
        runInShell: true,
        workingDirectory: projectDirectory,
      );

      return true;
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      return false;
    }
  }

  Future<bool> runPubGet({required String projectDirectory}) async {
    try {
      await Process.run(
        'flutter',
        ['pub', 'get'],
        runInShell: true,
        workingDirectory: projectDirectory,
      );

      return true;
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      return false;
    }
  }

  Future<bool> checkValidAndroidDirectoryAvailable(String projectDirectory) async {
    String pubspecPath = '$projectDirectory/android/app/src/main/AndroidManifest.xml';
    File pubspecFile = File(pubspecPath);

    return (await pubspecFile.exists()) ? true : false;
  }

  Future<bool> checkValidIosDirectoryAvailable(String projectDirectory) async {
    String delegateSwift = '$projectDirectory/ios/Runner/AppDelegate.swift';
    File delegateSwiftFile = File(delegateSwift);

    if (await delegateSwiftFile.exists()) {
      return true;
    } else {
      String delegateM = '$projectDirectory/ios/Runner/AppDelegate.m';
      File delegateMFile = File(delegateM);
      if (await delegateMFile.exists()) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> alreadyConfiguredForAndroid(String projectDirectory) async {
    String pubspecPath = '$projectDirectory/android/app/src/main/AndroidManifest.xml';
    File pubspecFile = File(pubspecPath);

    List<String> lines = await pubspecFile.readAsLines();

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().contains(AllCodes.androidConfigurationCheck)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> alreadyConfiguredForIos(String projectDirectory) async {
    String delegateSwift = '$projectDirectory/ios/Runner/AppDelegate.swift';
    File delegateSwiftFile = File(delegateSwift);

    if (await delegateSwiftFile.exists()) {
      List<String> lines = await delegateSwiftFile.readAsLines();

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].trim().contains(AllCodes.swiftConfigurationCheck)) {
          return true;
        }
      }
      return false;
    } else {
      String delegateM = '$projectDirectory/ios/Runner/AppDelegate.m';
      File delegateMFile = File(delegateM);
      if (await delegateMFile.exists()) {
        List<String> lines = await delegateMFile.readAsLines();

        for (int i = 0; i < lines.length; i++) {
          if (lines[i].trim().contains(AllCodes.iosConfigurationCheck)) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    }
  }

  Future<bool> checkPlatformConfigurationAvailable(String projectDirectory) async {
    return await alreadyConfiguredForAndroid(projectDirectory) && await alreadyConfiguredForIos(projectDirectory);
  }

  Future<void> addDependencyToAndroid(String projectDirectory, {required String apiKey}) async {
    String pubspecPath = '$projectDirectory/android/app/src/main/AndroidManifest.xml';
    File pubspecFile = File(pubspecPath);

    if (await pubspecFile.exists()) {
      List<String> lines = await pubspecFile.readAsLines();

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].trim() == "</application>") {
          lines.insert(i, AllCodes.androidConfiguration(apiKey));
          break;
        }
      }

      await pubspecFile.writeAsString(lines.join("\n"));
    }
  }

  Future<void> addDependencyToIos(String projectDirectory, {required String apiKey}) async {
    String delegateSwift = '$projectDirectory/ios/Runner/AppDelegate.swift';
    File delegateSwiftFile = File(delegateSwift);

    if (await delegateSwiftFile.exists()) {
      List<String> lines = await delegateSwiftFile.readAsLines();

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].trim().contains("return super.application")) {
          lines.insert(i, AllCodes.swiftConfiguration(apiKey));
          break;
        }
      }

      await delegateSwiftFile.writeAsString(lines.join("\n"));
    } else {
      String delegateM = '$projectDirectory/ios/Runner/AppDelegate.m';
      File delegateMFile = File(delegateM);

      if (await delegateMFile.exists()) {
        List<String> lines = await delegateMFile.readAsLines();

        for (int i = 0; i < lines.length; i++) {
          if (lines[i].trim().contains("launchOptions {")) {
            lines.insert(i, AllCodes.iosConfiguration(apiKey));
            break;
          }
        }

        await delegateMFile.writeAsString(lines.join("\n"));
      } else {
        debugPrint("AppDelegate.swift and AppDelegate.m not found in $projectDirectory");
      }
    }
  }

  Future<bool> addGoogleMapWidgetToMainScreen(String directoryPath) async {
    try {
      String pubspecPath = '$directoryPath/lib/main.dart';
      File mainDartFile = File(pubspecPath);

      if (await mainDartFile.exists()) {
        await mainDartFile.writeAsString(AllCodes.mapCode, mode: FileMode.write);
        return true;
      } else {
        return false;
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      return false;
    }
  }
}
