import 'dart:developer';

import 'package:automates_integration_package/helper_controller.dart';
import 'package:automates_integration_package/helper_service.dart';
import 'package:automates_integration_package/widget/task_tile.dart';
import 'package:automates_integration_package/widget/sub_task_tile.dart';
import 'package:automates_integration_package/widget/sub_task_text_field_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'global_variable.dart';
import 'providers.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.setMinimumSize(const Size(800, 600));

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late TextEditingController textEditingController;
  late HelperController controller;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    controller = HelperController(
      context: context,
      ref: ref,
      service: HelperService(),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Automated Package Integration",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              "Select a Flutter project to continue",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 32),
            TaskTile(index: 1, title: "Prepare your workspace"),
            Consumer(builder: (context, ref, _) {
              final currentState = ref.watch(currentStateProvider);
              final selectedDirectory = ref.watch(selectedDirectoryProvider);

              log("current state :: $currentState");
              return Column(
                children: [
                  SubTaskTile(
                    title: "Select FLUTTER project ${selectedDirectory != null ? "(${selectedDirectory.split("/").last})" : ""}",
                    onTap: () {
                      // ref.read(resetEverythingProvider.notifier).state = true;
                      if (currentState == AllState.selectingFlutterProject ||
                          currentState == AllState.addingPackage ||
                          currentState == AllState.addingPubGet ||
                          currentState == AllState.addingAndroidConfig ||
                          currentState == AllState.addingIosConfig ||
                          currentState == AllState.addingMapWidget) {
                        return;
                      }
                      ref.refresh(selectedDirectoryProvider);
                      ref.refresh(currentStateProvider);
                      textEditingController.clear();
                      controller.selectDirectory();
                    },
                    dependentState: [
                      AllState.selectingFlutterProject,
                      AllState.errorFlutterProject,
                    ],
                    currentState: currentState,
                    loadingState: AllState.selectingFlutterProject,
                    errorState: AllState.errorFlutterProject,
                  ),
                  SubTaskTile(
                    title: "Add google_maps_flutter to pubspec.yaml.",
                    dependentState: [
                      AllState.addingPackage,
                      AllState.errorAddedPackage,
                    ],
                    currentState: currentState,
                    loadingState: AllState.addingPackage,
                    errorState: AllState.errorAddedPackage,
                  ),
                  SubTaskTile(
                    title: "Run flutter pub get automatically.",
                    dependentState: [
                      // AllProcess.initPubGet,
                      AllState.addingPubGet,
                      AllState.errorAddingPubGet,
                      // AllProcess.addedPubGet,
                    ],
                    currentState: currentState,
                    loadingState: AllState.addingPubGet,
                    errorState: AllState.errorAddingPubGet,
                  ),
                  TaskTile(
                    index: 2,
                    title: "API Key Management",
                  ),
                  if (AllState.errorFlutterProject != currentState && selectedDirectory != null) ...[
                    Consumer(builder: (context, ref, _) {
                      final asyncAlreadyConfigured = ref.watch(platformConfigurationExistProvider(selectedDirectory ?? ""));

                      return asyncAlreadyConfigured.when(
                        data: (alreadyConfigured) {
                          return SubTaskTextFieldTile(
                            dependentState: [
                              // AllProcess.initApiKey,
                              AllState.addingApiKey,
                              // AllProcess.addedApiKey,
                            ],
                            currentState: currentState,
                            loadingState: AllState.addingApiKey,
                            controller: textEditingController,
                            onConfirmTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                controller.configureAndroidAndIos(
                                  selectedDirectory,
                                  textEditingController.text,
                                );
                              } else {
                                controller.showSnackBar(context, message: "Please enter a Google Map API key");
                              }
                            },
                            onSkipTap: () {
                              if (!alreadyConfigured) {
                                controller.showSnackBar(context,
                                    message: "You must submit API key.\nBecause, platform wise API configured not found.");
                              } else {
                                controller.demoIntegration(selectedDirectory);
                              }
                            },
                          );
                        },
                        error: (error, _) {
                          log(error.toString());
                          log(_.toString());
                          return SizedBox();
                        },
                        loading: () => SizedBox(),
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      final existAndroid = ref.watch(androidExistProvider(selectedDirectory ?? ""));

                      return existAndroid.when(
                        data: (exist) {
                          if (exist) {
                            return SubTaskTile(
                              title: "Configure Android map configuration.",
                              dependentState: [
                                // AllProcess.initAndroidConfig,
                                AllState.addingAndroidConfig,
                                AllState.loadingAddingAndroidConfig,
                                // AllProcess.addedAndroidConfig,
                              ],
                              currentState: currentState,
                              loadingState: AllState.addingAndroidConfig,
                              errorState: AllState.loadingAddingAndroidConfig,
                              icon: Icon(Icons.android),
                            );
                          }
                          return SizedBox();
                        },
                        error: (error, _) {
                          log(error.toString());
                          log(_.toString());
                          return SizedBox();
                        },
                        loading: () => SizedBox(),
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      final existAndroid = ref.watch(iosExistProvider(selectedDirectory ?? ""));

                      return existAndroid.when(
                        data: (exist) {
                          if (exist) {
                            return SubTaskTile(
                              title: "Configure iOS map configuration.",
                              dependentState: [
                                // AllProcess.initIosConfig,
                                AllState.addingIosConfig,
                                // AllProcess.addedIosConfig,
                              ],
                              currentState: currentState,
                              loadingState: AllState.addingIosConfig,
                              icon: Icon(Icons.apple),
                            );
                          }
                          return SizedBox();
                        },
                        error: (error, _) {
                          log(error.toString());
                          log(_.toString());
                          return SizedBox();
                        },
                        loading: () => SizedBox(),
                      );
                    }),
                  ],
                  TaskTile(index: 3, title: "Demo Integration"),
                  if (AllState.errorFlutterProject != currentState && selectedDirectory != null) ...[
                    SubTaskTile(
                      title: "Add Google Map widget to the main screen.",
                      dependentState: [
                        // AllProcess.initMapWidget,
                        AllState.addingMapWidget,
                        AllState.errorAddedMapWidget,
                        // AllProcess.addedMapWidget,
                      ],
                      currentState: currentState,
                      loadingState: AllState.addingMapWidget,
                      errorState: AllState.errorAddedMapWidget,
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
