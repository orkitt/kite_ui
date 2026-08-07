enum ProjectPreset {
  clean,
  vanilla;

  String get templateId => switch (this) {
    ProjectPreset.clean => 'project.clean',
    ProjectPreset.vanilla => 'project.vanilla',
  };

  // String get architecture => switch (this) {
  //   ProjectPreset.clean => 'clean',
  //   ProjectPreset.vanilla => 'vanilla',
  // };

  // String get stateManagement => switch (this) {
  //   ProjectPreset.clean => 'riverpod',
  //   ProjectPreset.vanilla => 'none',
  // };
}
