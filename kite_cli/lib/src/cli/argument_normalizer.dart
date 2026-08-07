List<String> normalizeArguments(List<String> arguments) {
  if (arguments.isEmpty) {
    return const <String>[];
  }

  final first = arguments.first;

  final featureShorthand = RegExp(
    r'^--feat:([a-z][a-z0-9_-]*)$',
  ).firstMatch(first);
  if (featureShorthand != null) {
    if (arguments.length < 2) {
      return const <String>['feature'];
    }

    return <String>[
      'feature',
      arguments[1],
      '--architecture',
      featureShorthand.group(1)!,
      ...arguments.skip(2),
    ];
  }

  if (first == '--widget' || first == '--component') {
    return <String>['component', ...arguments.skip(1)];
  }

  final widgetEquals = RegExp(
    r'^--(?:widget|component)=(.+)$',
  ).firstMatch(first);
  if (widgetEquals != null) {
    return <String>['component', widgetEquals.group(1)!, ...arguments.skip(1)];
  }

  if (first == '--state') {
    return <String>['state', ...arguments.skip(1)];
  }

  final stateShorthand = RegExp(
    r'^--state:([a-z][a-z0-9_-]*)$',
  ).firstMatch(first);
  if (stateShorthand != null) {
    return <String>['state', stateShorthand.group(1)!, ...arguments.skip(1)];
  }

  if (first == '--api') {
    return <String>['api', ...arguments.skip(1)];
  }

  final apiShorthand = RegExp(r'^--api:([a-z][a-z0-9_-]*)$').firstMatch(first);
  if (apiShorthand != null) {
    return <String>['api', apiShorthand.group(1)!, ...arguments.skip(1)];
  }

  if (first == 'feat') {
    return <String>['feature', ...arguments.skip(1)];
  }

  if (first == 'g' || first == 'generate') {
    if (arguments.length >= 2 &&
        (arguments[1] == 'feature' || arguments[1] == 'feat')) {
      return <String>['feature', ...arguments.skip(2)];
    }
    if (arguments.length >= 2 &&
        (arguments[1] == 'component' || arguments[1] == 'widget')) {
      return <String>['component', ...arguments.skip(2)];
    }
  }

  return List<String>.unmodifiable(arguments);
}
