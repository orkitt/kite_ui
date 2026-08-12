import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../naming/name_converter.dart';

final class KiteShellNavigationConfig {
  const KiteShellNavigationConfig({
    this.visible = true,
    this.label,
  });

  final bool visible;
  final String? label;

  factory KiteShellNavigationConfig.fromYaml(Object? value) {
    final map = KiteConfig._map(value);
    final label = KiteConfig._nullableString(map['label']);
    return KiteShellNavigationConfig(
      visible: KiteConfig._boolean(map['visible'], true),
      label: label,
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'visible': visible,
        if (label != null) 'label': label,
      };
}

final class KiteShellBranchConfig {
  const KiteShellBranchConfig({
    required this.name,
    required this.path,
    required this.feature,
    this.architecture = 'clean',
    this.navigation = const KiteShellNavigationConfig(),
  });

  final String name;
  final String path;
  final String feature;
  final String architecture;
  final KiteShellNavigationConfig navigation;

  factory KiteShellBranchConfig.fromYaml(
    Object? value, {
    required String defaultArchitecture,
  }) {
    final map = KiteConfig._map(value);
    final name = KiteConfig._string(map['name'], '');
    final path = KiteConfig._string(map['path'], '');
    final explicitFeature = KiteConfig._nullableString(map['feature']);
    final feature = explicitFeature ??
        (name.isEmpty ? '' : NameConverter(name).snakeCase);
    final architecture = KiteConfig._string(
      map['architecture'],
      defaultArchitecture,
    );
    if (name.isEmpty ||
        feature.isEmpty ||
        path.isEmpty ||
        !path.startsWith('/') ||
        (architecture != 'clean' && architecture != 'mvc')) {
      throw const FormatException('Invalid shell branch in kite.yaml.');
    }
    return KiteShellBranchConfig(
      name: name,
      path: path,
      feature: feature,
      architecture: architecture,
      navigation: KiteShellNavigationConfig.fromYaml(map['navigation']),
    );
  }

  KiteShellBranchConfig copyWith({
    String? name,
    String? path,
    String? feature,
    String? architecture,
    KiteShellNavigationConfig? navigation,
  }) {
    return KiteShellBranchConfig(
      name: name ?? this.name,
      path: path ?? this.path,
      feature: feature ?? this.feature,
      architecture: architecture ?? this.architecture,
      navigation: navigation ?? this.navigation,
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'name': name,
        'path': path,
        'feature': feature,
        'architecture': architecture,
        'navigation': navigation.toYamlMap(),
      };
}

final class KiteShellConfig {
  const KiteShellConfig({
    this.enabled = false,
    this.branches = const <KiteShellBranchConfig>[],
  });

  final bool enabled;
  final List<KiteShellBranchConfig> branches;

  factory KiteShellConfig.fromYaml(
    Object? value, {
    required String defaultArchitecture,
  }) {
    final map = KiteConfig._map(value);
    final branches = KiteConfig._list(map['branches'])
        .map(
          (item) => KiteShellBranchConfig.fromYaml(
            item,
            defaultArchitecture: defaultArchitecture,
          ),
        )
        .toList(growable: false);
    return KiteShellConfig(
      enabled: KiteConfig._boolean(map['enabled'], false),
      branches: List<KiteShellBranchConfig>.unmodifiable(branches),
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'enabled': enabled,
        'branches': branches
            .map((item) => item.toYamlMap())
            .toList(growable: false),
      };
}

final class KiteRouteParameterConfig {
  const KiteRouteParameterConfig({
    required this.name,
    required this.type,
    this.required = true,
  });

  static const Set<String> supportedTypes = <String>{
    'String',
    'int',
    'double',
    'bool',
  };

  final String name;
  final String type;
  final bool required;

  factory KiteRouteParameterConfig.fromYaml(Object? value) {
    final map = KiteConfig._map(value);
    final name = KiteConfig._string(map['name'], '');
    final type = KiteConfig._string(map['type'], 'String');
    final required = KiteConfig._boolean(map['required'], true);
    final validName = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(name);
    if (!validName || !supportedTypes.contains(type)) {
      throw FormatException(
        'Invalid route parameter `$name:$type` in kite.yaml. Supported '
        'types: ${supportedTypes.join(', ')}.',
      );
    }
    return KiteRouteParameterConfig(
      name: name,
      type: type,
      required: required,
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'name': name,
        'type': type,
        'required': required,
      };
}

final class KiteRouteParametersConfig {
  const KiteRouteParametersConfig({
    this.path = const <KiteRouteParameterConfig>[],
  });

  final List<KiteRouteParameterConfig> path;

  factory KiteRouteParametersConfig.fromYaml(Object? value) {
    final map = KiteConfig._map(value);
    final pathParameters = KiteConfig._list(map['path'])
        .map(KiteRouteParameterConfig.fromYaml)
        .toList(growable: false);
    final names = <String>{};
    for (final parameter in pathParameters) {
      if (!parameter.required) {
        throw FormatException(
          'Path parameter `${parameter.name}` must be required. Optional URL '
          'state should use query parameters in a future Kite release.',
        );
      }
      if (!names.add(parameter.name)) {
        throw FormatException(
          'Duplicate route path parameter `${parameter.name}` in kite.yaml.',
        );
      }
    }
    return KiteRouteParametersConfig(
      path: List<KiteRouteParameterConfig>.unmodifiable(pathParameters),
    );
  }

  bool get hasPathParameters => path.isNotEmpty;

  Map<String, Object?> toYamlMap() => <String, Object?>{
        if (path.isNotEmpty)
          'path': path.map((item) => item.toYamlMap()).toList(growable: false),
      };
}

final class KiteRouteConfig {
  const KiteRouteConfig({
    required this.feature,
    required this.path,
    required this.segment,
    required this.branch,
    this.architecture = 'clean',
    this.parameters = const KiteRouteParametersConfig(),
  });

  final String feature;
  final String path;
  final String segment;
  final String branch;
  final String architecture;
  final KiteRouteParametersConfig parameters;

  factory KiteRouteConfig.fromYaml(
    Object? value, {
    required String defaultArchitecture,
  }) {
    final map = KiteConfig._map(value);
    final feature = KiteConfig._string(map['feature'], '');
    final path = KiteConfig._string(map['path'], '');
    final segment = KiteConfig._string(map['segment'], '');
    final branch = KiteConfig._string(map['branch'], 'root');
    final architecture = KiteConfig._string(
      map['architecture'],
      defaultArchitecture,
    );
    if (feature.isEmpty ||
        segment.isEmpty ||
        path.isEmpty ||
        !path.startsWith('/') ||
        (architecture != 'clean' && architecture != 'mvc')) {
      throw const FormatException('Invalid generated route in kite.yaml.');
    }
    return KiteRouteConfig(
      feature: feature,
      path: path,
      segment: segment,
      branch: branch,
      architecture: architecture,
      parameters: KiteRouteParametersConfig.fromYaml(map['parameters']),
    );
  }

  KiteRouteConfig copyWith({
    String? feature,
    String? path,
    String? segment,
    String? branch,
    String? architecture,
    KiteRouteParametersConfig? parameters,
  }) {
    return KiteRouteConfig(
      feature: feature ?? this.feature,
      path: path ?? this.path,
      segment: segment ?? this.segment,
      branch: branch ?? this.branch,
      architecture: architecture ?? this.architecture,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'feature': feature,
        'path': path,
        'segment': segment,
        'branch': branch,
        'architecture': architecture,
        if (parameters.path.isNotEmpty) 'parameters': parameters.toYamlMap(),
      };
}

final class KiteRoutingConfig {
  const KiteRoutingConfig({
    this.type = 'go_router',
    this.autoRegisterFeatures = true,
    this.shell = const KiteShellConfig(),
    this.routes = const <KiteRouteConfig>[],
  });

  final String type;
  final bool autoRegisterFeatures;
  final KiteShellConfig shell;
  final List<KiteRouteConfig> routes;

  factory KiteRoutingConfig.fromYaml(
    Object? value, {
    required String defaultArchitecture,
  }) {
    final map = KiteConfig._map(value);
    final routes = KiteConfig._list(map['routes'])
        .map(
          (item) => KiteRouteConfig.fromYaml(
            item,
            defaultArchitecture: defaultArchitecture,
          ),
        )
        .toList(growable: false);
    return KiteRoutingConfig(
      type: KiteConfig._string(map['type'], 'go_router'),
      autoRegisterFeatures: KiteConfig._boolean(
        map['auto_register_features'],
        true,
      ),
      shell: KiteShellConfig.fromYaml(
        map['shell'],
        defaultArchitecture: defaultArchitecture,
      ),
      routes: List<KiteRouteConfig>.unmodifiable(routes),
    );
  }

  KiteRoutingConfig copyWith({
    String? type,
    bool? autoRegisterFeatures,
    KiteShellConfig? shell,
    List<KiteRouteConfig>? routes,
  }) {
    return KiteRoutingConfig(
      type: type ?? this.type,
      autoRegisterFeatures: autoRegisterFeatures ?? this.autoRegisterFeatures,
      shell: shell ?? this.shell,
      routes: List<KiteRouteConfig>.unmodifiable(routes ?? this.routes),
    );
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'type': type,
        'auto_register_features': autoRegisterFeatures,
        'shell': shell.toYamlMap(),
        'routes': routes
            .map((item) => item.toYamlMap())
            .toList(growable: false),
      };
}

final class KiteDatabaseConfig {
  const KiteDatabaseConfig({
    this.enabled = false,
    this.type = 'none',
  });

  final bool enabled;
  final String type;

  factory KiteDatabaseConfig.fromYaml(Object? value) {
    final map = KiteConfig._map(value);
    final enabled = KiteConfig._boolean(map['enabled'], false);
    final type = KiteConfig._string(map['type'], enabled ? 'isar' : 'none');
    if (enabled && type != 'isar') {
      throw FormatException(
        'Unsupported database type `$type` in kite.yaml. Available: isar.',
      );
    }
    return KiteDatabaseConfig(enabled: enabled, type: type);
  }

  Map<String, Object?> toYamlMap() => <String, Object?>{
        'enabled': enabled,
        'type': type,
      };
}

final class KiteConfig {
  const KiteConfig({
    this.projectPreset = 'clean',
    this.sourceDirectory = 'lib',
    this.featureDirectory = 'lib/features',
    this.architecture = 'clean',
    this.routing = const KiteRoutingConfig(),
    this.database = const KiteDatabaseConfig(),
    this.stateManagement = 'riverpod',
    this.formatAfterGeneration = true,
    this.installDependencies = true,
    this.conflictStrategy = 'skip',
  });

  final String projectPreset;
  final String sourceDirectory;
  final String featureDirectory;
  final String architecture;
  final KiteRoutingConfig routing;
  final KiteDatabaseConfig database;
  final String stateManagement;
  final bool formatAfterGeneration;
  final bool installDependencies;
  final String conflictStrategy;

  String get router => routing.type;

  factory KiteConfig.load(Directory projectRoot) {
    final file = File(p.join(projectRoot.path, 'kite.yaml'));
    if (!file.existsSync()) {
      return const KiteConfig();
    }

    final Object? document = loadYaml(file.readAsStringSync());
    if (document is! YamlMap) {
      throw const FormatException('kite.yaml is not valid YAML.');
    }

    final project = _map(document['project']);
    final architectureMap = _map(document['architecture']);
    final architectureType = _string(architectureMap['type'], 'clean');
    final stateManagement = _map(document['state_management']);
    final generation = _map(document['generation']);

    return KiteConfig(
      projectPreset: _string(project['preset'], 'clean'),
      sourceDirectory: _string(project['source_directory'], 'lib'),
      featureDirectory: _string(
        architectureMap['feature_directory'],
        'lib/features',
      ),
      architecture: architectureType,
      routing: KiteRoutingConfig.fromYaml(
        document['routing'],
        defaultArchitecture: architectureType,
      ),
      database: KiteDatabaseConfig.fromYaml(document['database']),
      stateManagement: _string(stateManagement['type'], 'riverpod'),
      formatAfterGeneration: _boolean(
        generation['format_after_generation'],
        true,
      ),
      installDependencies: _boolean(generation['install_dependencies'], true),
      conflictStrategy: _string(generation['conflict_strategy'], 'skip'),
    );
  }

  KiteConfig copyWith({
    String? projectPreset,
    String? sourceDirectory,
    String? featureDirectory,
    String? architecture,
    KiteRoutingConfig? routing,
    KiteDatabaseConfig? database,
    String? stateManagement,
    bool? formatAfterGeneration,
    bool? installDependencies,
    String? conflictStrategy,
  }) {
    return KiteConfig(
      projectPreset: projectPreset ?? this.projectPreset,
      sourceDirectory: sourceDirectory ?? this.sourceDirectory,
      featureDirectory: featureDirectory ?? this.featureDirectory,
      architecture: architecture ?? this.architecture,
      routing: routing ?? this.routing,
      database: database ?? this.database,
      stateManagement: stateManagement ?? this.stateManagement,
      formatAfterGeneration:
          formatAfterGeneration ?? this.formatAfterGeneration,
      installDependencies: installDependencies ?? this.installDependencies,
      conflictStrategy: conflictStrategy ?? this.conflictStrategy,
    );
  }

  Map<String, Object?> toTemplateValues() => <String, Object?>{
        'sourceDirectory': sourceDirectory,
        'featureDirectory': featureDirectory,
        'architecture': architecture,
        'router': routing.type,
        'stateManagement': stateManagement,
      };

  static Map<Object?, Object?> _map(Object? value) {
    return value is YamlMap ? value : const <Object?, Object?>{};
  }

  static List<Object?> _list(Object? value) {
    return value is YamlList ? value.cast<Object?>() : const <Object?>[];
  }

  static String _string(Object? value, String fallback) {
    return value is String && value.trim().isNotEmpty ? value.trim() : fallback;
  }

  static String? _nullableString(Object? value) {
    return value is String && value.trim().isNotEmpty ? value.trim() : null;
  }

  static bool _boolean(Object? value, bool fallback) {
    return value is bool ? value : fallback;
  }
}

final class KiteConfigStore {
  const KiteConfigStore();

  Future<void> writeRouting({
    required Directory projectRoot,
    required KiteRoutingConfig routing,
  }) async {
    final file = File(p.join(projectRoot.path, 'kite.yaml'));
    if (!file.existsSync()) {
      throw StateError('kite.yaml not found. Run `kite init` first.');
    }

    final Object? document = loadYaml(await file.readAsString());
    if (document is! YamlMap) {
      throw const FormatException('kite.yaml is not valid YAML.');
    }

    final root = _toMutableMap(document);
    final existingRouting = root['routing'];
    final routingMap = existingRouting is Map<String, Object?>
        ? Map<String, Object?>.from(existingRouting)
        : <String, Object?>{};
    routingMap
      ..['type'] = routing.type
      ..['auto_register_features'] = routing.autoRegisterFeatures
      ..['shell'] = routing.shell.toYamlMap()
      ..['routes'] = routing.routes
          .map((item) => item.toYamlMap())
          .toList(growable: false);
    root['routing'] = routingMap;

    await file.writeAsString('${_YamlWriter().write(root)}\n');
  }

  Future<void> writeDatabase({
    required Directory projectRoot,
    required KiteDatabaseConfig database,
  }) async {
    final file = File(p.join(projectRoot.path, 'kite.yaml'));
    if (!file.existsSync()) {
      throw StateError('kite.yaml not found. Run `kite init` first.');
    }

    final Object? document = loadYaml(await file.readAsString());
    if (document is! YamlMap) {
      throw const FormatException('kite.yaml is not valid YAML.');
    }

    final root = _toMutableMap(document);
    root['database'] = database.toYamlMap();
    await file.writeAsString('${_YamlWriter().write(root)}\n');
  }

  Map<String, Object?> _toMutableMap(YamlMap map) {
    return <String, Object?>{
      for (final entry in map.entries)
        entry.key.toString(): _toMutableValue(entry.value),
    };
  }

  Object? _toMutableValue(Object? value) {
    if (value is YamlMap) {
      return _toMutableMap(value);
    }
    if (value is YamlList) {
      return value.map(_toMutableValue).toList(growable: false);
    }
    return value;
  }
}

final class _YamlWriter {
  String write(Map<String, Object?> document) {
    final buffer = StringBuffer();
    _writeMap(buffer, document, 0);
    return buffer.toString().trimRight();
  }

  void _writeMap(StringBuffer buffer, Map<String, Object?> map, int indent) {
    for (final entry in map.entries) {
      final prefix = ''.padLeft(indent);
      final value = entry.value;
      if (value is Map<String, Object?>) {
        buffer.writeln('$prefix${entry.key}:');
        if (value.isNotEmpty) {
          _writeMap(buffer, value, indent + 2);
        }
      } else if (value is List<Object?>) {
        if (value.isEmpty) {
          buffer.writeln('$prefix${entry.key}: []');
        } else {
          buffer.writeln('$prefix${entry.key}:');
          _writeList(buffer, value, indent + 2);
        }
      } else {
        buffer.writeln('$prefix${entry.key}: ${_scalar(value)}');
      }
    }
  }

  void _writeList(StringBuffer buffer, List<Object?> list, int indent) {
    final prefix = ''.padLeft(indent);
    for (final item in list) {
      if (item is Map<String, Object?>) {
        if (item.isEmpty) {
          buffer.writeln('${prefix}- {}');
          continue;
        }
        final entries = item.entries.toList(growable: false);
        final first = entries.first;
        if (first.value is Map<String, Object?> ||
            first.value is List<Object?>) {
          buffer.writeln('${prefix}- ${first.key}:');
          _writeNested(buffer, first.value, indent + 4);
        } else {
          buffer.writeln('${prefix}- ${first.key}: ${_scalar(first.value)}');
        }
        for (final entry in entries.skip(1)) {
          final value = entry.value;
          final nestedPrefix = ''.padLeft(indent + 2);
          if (value is Map<String, Object?> || value is List<Object?>) {
            buffer.writeln('$nestedPrefix${entry.key}:');
            _writeNested(buffer, value, indent + 4);
          } else {
            buffer.writeln('$nestedPrefix${entry.key}: ${_scalar(value)}');
          }
        }
      } else {
        buffer.writeln('$prefix- ${_scalar(item)}');
      }
    }
  }

  void _writeNested(StringBuffer buffer, Object? value, int indent) {
    if (value is Map<String, Object?>) {
      _writeMap(buffer, value, indent);
    } else if (value is List<Object?>) {
      _writeList(buffer, value, indent);
    }
  }

  String _scalar(Object? value) {
    if (value == null) {
      return 'null';
    }
    if (value is bool || value is num) {
      return value.toString();
    }
    final text = value.toString();
    final plain = RegExp(r'^[A-Za-z0-9_./-]+$').hasMatch(text) &&
        !const <String>{'true', 'false', 'null', 'yes', 'no'}.contains(
          text.toLowerCase(),
        );
    return plain ? text : jsonEncode(text);
  }
}
