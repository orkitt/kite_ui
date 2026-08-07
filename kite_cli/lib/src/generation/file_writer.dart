import 'dart:io';

import 'package:path/path.dart' as p;

import '../logging/kite_logger.dart';
import 'conflict_strategy.dart';
import 'file_checksum.dart';
import 'generation_plan.dart';
import 'generation_result.dart';

final class GenerationConflictException implements Exception {
  const GenerationConflictException(this.message);

  final String message;

  @override
  String toString() => message;
}

enum _WriteAction {
  create,
  update,
  unchanged,
  skip,
}

final class _ResolvedFile {
  const _ResolvedFile(this.file, this.action);

  final PlannedFile file;
  final _WriteAction action;
}

final class FileWriter {
  const FileWriter({
    this.logger = const KiteLogger(),
  });

  final KiteLogger logger;

  Future<GenerationResult> write({
    required Directory root,
    required GenerationPlan plan,
    required ConflictStrategy conflictStrategy,
    required bool dryRun,
  }) async {
    final resolved = <_ResolvedFile>[];
    var overwriteAll = conflictStrategy == ConflictStrategy.overwrite;

    for (final planned in plan.files) {
      final target = File(p.join(root.path, planned.relativePath));
      if (!target.existsSync()) {
        resolved.add(_ResolvedFile(planned, _WriteAction.create));
        continue;
      }

      final existing = await target.readAsString();
      if (existing == planned.content) {
        resolved.add(_ResolvedFile(planned, _WriteAction.unchanged));
        continue;
      }

      if (overwriteAll) {
        resolved.add(_ResolvedFile(planned, _WriteAction.update));
        continue;
      }

      switch (conflictStrategy) {
        case ConflictStrategy.overwrite:
          resolved.add(_ResolvedFile(planned, _WriteAction.update));
        case ConflictStrategy.skip:
          resolved.add(_ResolvedFile(planned, _WriteAction.skip));
        case ConflictStrategy.fail:
          throw GenerationConflictException(
            'File already exists: ${planned.relativePath}',
          );
        case ConflictStrategy.ask:
          final decision = await _prompt(planned.relativePath);
          switch (decision) {
            case 'o':
              resolved.add(_ResolvedFile(planned, _WriteAction.update));
            case 'a':
              overwriteAll = true;
              resolved.add(_ResolvedFile(planned, _WriteAction.update));
            case 's':
              resolved.add(_ResolvedFile(planned, _WriteAction.skip));
            default:
              throw const GenerationConflictException(
                'Generation cancelled by the user.',
              );
          }
      }
    }

    final results = <GeneratedFileResult>[];
    for (final item in resolved) {
      final target = File(p.join(root.path, item.file.relativePath));
      switch (item.action) {
        case _WriteAction.create:
        case _WriteAction.update:
          if (!dryRun) {
            await target.parent.create(recursive: true);
            await target.writeAsString(item.file.content);
          }
          results.add(
            GeneratedFileResult(
              relativePath: item.file.relativePath,
              status: item.action == _WriteAction.create
                  ? GeneratedFileStatus.created
                  : GeneratedFileStatus.updated,
              checksum: FileChecksum.content(item.file.content),
            ),
          );
        case _WriteAction.unchanged:
          results.add(
            GeneratedFileResult(
              relativePath: item.file.relativePath,
              status: GeneratedFileStatus.unchanged,
              checksum: FileChecksum.content(item.file.content),
            ),
          );
        case _WriteAction.skip:
          results.add(
            GeneratedFileResult(
              relativePath: item.file.relativePath,
              status: GeneratedFileStatus.skipped,
            ),
          );
      }
    }

    return GenerationResult(List<GeneratedFileResult>.unmodifiable(results));
  }

  Future<String> _prompt(String relativePath) async {
    if (!stdin.hasTerminal) {
      throw GenerationConflictException(
        'File already exists: $relativePath. Use --force or --skip-existing.',
      );
    }

    stdout.write(
      'File $relativePath exists. [o]verwrite, overwrite [a]ll, [s]kip, '
      '[q]uit: ',
    );
    return (stdin.readLineSync() ?? 'q').trim().toLowerCase();
  }
}
