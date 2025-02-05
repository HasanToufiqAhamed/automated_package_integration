import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'global_variable.dart';
import 'helper_service.dart';
import 'providers.dart';

class HelperController {
  BuildContext context;
  WidgetRef ref;
  HelperService service;

  HelperController({
    required this.context,
    required this.ref,
    required this.service,
  });

  void showSnackBar(
    BuildContext context, {
    required String message,
    bool success = false,
    int duration = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        backgroundColor: success ? Colors.green : Colors.redAccent,
      ),
    );
  }

  Future<void> selectDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      ref.read(currentStateProvider.notifier).state = AllState.errorFlutterProject;
    } else {
      bool flutterProject = await service.checkIsItFlutterProject(selectedDirectory);
      if (flutterProject) {
        ref.read(selectedDirectoryProvider.notifier).state = selectedDirectory;

        ref.read(currentStateProvider.notifier).state = AllState.addingPackage;

        bool addedPackage = await service.addPackage(
          projectDirectory: selectedDirectory,
          packageName: "google_maps_flutter",
        );

        if (addedPackage) {
          ref.read(currentStateProvider.notifier).state = AllState.addingPubGet;
          bool completePubGet = await service.runPubGet(projectDirectory: selectedDirectory);

          if (completePubGet) {
            ///go to Step 2
            apiKeyManagement(projectDirectory: selectedDirectory);
          } else {
            ref.read(currentStateProvider.notifier).state = AllState.errorAddingPubGet;
          }
        } else {
          ref.read(currentStateProvider.notifier).state = AllState.errorAddedPackage;
        }
      } else {
        ref.read(currentStateProvider.notifier).state = AllState.errorFlutterProject;
        showSnackBar(
          context,
          message: "Please add a valid Flutter project directory to continue",
        );
      }
    }
  }

  void apiKeyManagement({required String projectDirectory}) {
    ref.read(currentStateProvider.notifier).state = AllState.addingApiKey;
  }

  Future<void> configureAndroidAndIos(String? selectedDirectory, String text) async {
    if (await service.checkValidAndroidDirectoryAvailable(selectedDirectory!)) {
      ref.read(currentStateProvider.notifier).state = AllState.addingAndroidConfig;
      await Future.delayed(Duration(seconds: 2));
      await service.addDependencyToAndroid(selectedDirectory, apiKey: text);
    }
    if (await service.checkValidIosDirectoryAvailable(selectedDirectory)) {
      ref.read(currentStateProvider.notifier).state = AllState.addingIosConfig;
      await Future.delayed(Duration(seconds: 2));
      await service.addDependencyToIos(selectedDirectory, apiKey: text);
    }

    ///go to Step 3
    demoIntegration(selectedDirectory);
  }

  Future<void> demoIntegration(String? selectedDirectory) async {
    ref.read(currentStateProvider.notifier).state = AllState.addingMapWidget;

    ///add demo map view
    await Future.delayed(Duration(seconds: 2));
    bool writeMapCode = await service.addGoogleMapWidgetToMainScreen(selectedDirectory!);
    if (writeMapCode) {
      ref.read(currentStateProvider.notifier).state = AllState.allDone;

      showSnackBar(context,
          message: """All good! Package, API Key and Demo integration done.\nPress "Select FLUTTER project" to do again.""",
          success: true,
          duration: 4);
    } else {
      ref.read(currentStateProvider.notifier).state = AllState.errorAddedMapWidget;
    }
  }

// bool checkReset() {
//   return ref.read(resetEverythingProvider);
// }
}
