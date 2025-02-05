enum AllState {
  init,
  selectingFlutterProject,
  errorFlutterProject,
  addingPackage,
  errorAddedPackage,
  addingPubGet,
  errorAddingPubGet,
  addingApiKey,
  addingAndroidConfig,
  loadingAddingAndroidConfig,
  addingIosConfig,
  addingMapWidget,
  errorAddedMapWidget,
  allDone,
}

List<AllState> stateSequence = [
  AllState.init,
  AllState.selectingFlutterProject,
  AllState.errorFlutterProject,

  ///
  AllState.addingPackage,
  AllState.errorAddedPackage,

  ///
  AllState.addingPubGet,
  AllState.errorAddingPubGet,

  ///
  AllState.addingApiKey,

  ///
  AllState.addingAndroidConfig,
  AllState.loadingAddingAndroidConfig,

  ///
  AllState.addingIosConfig,

  ///
  AllState.addingMapWidget,
  AllState.errorAddedMapWidget,

  ///
  AllState.allDone,
];