enum GeneratedFileStatus {
  created,
  updated,
  unchanged,
  skipped,
}

final class GeneratedFileResult {
  const GeneratedFileResult({
    required this.relativePath,
    required this.status,
    this.checksum,
  });

  final String relativePath;
  final GeneratedFileStatus status;
  final String? checksum;
}

final class GenerationResult {
  const GenerationResult(this.files);

  final List<GeneratedFileResult> files;

  int count(GeneratedFileStatus status) =>
      files.where((item) => item.status == status).length;
}
