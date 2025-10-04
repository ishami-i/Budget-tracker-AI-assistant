import 'dart:convert';
import 'dart:io';

/// Usage:
/// dart run tool/check_coverage.dart coverage/lcov.info 0.90
///
/// Exits with non-zero status if coverage is below the threshold.
void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run tool/check_coverage.dart <lcov_path> <threshold>',
    );
    exit(2);
  }

  final lcovPath = args[0];
  final threshold = double.tryParse(args[1]);
  if (threshold == null || threshold <= 0 || threshold > 1) {
    stderr.writeln('Threshold must be a decimal between 0 and 1 (e.g., 0.9).');
    exit(2);
  }

  final file = File(lcovPath);
  if (!await file.exists()) {
    stderr.writeln('lcov file not found at: $lcovPath');
    exit(2);
  }

  final lines = const LineSplitter().convert(await file.readAsString());

  int total = 0;
  int covered = 0;

  for (final line in lines) {
    if (line.startsWith('DA:')) {
      // Format: DA:<line number>,<execution count>
      final parts = line.substring(3).split(',');
      if (parts.length == 2) {
        final hits = int.tryParse(parts[1]) ?? 0;
        total += 1;
        if (hits > 0) covered += 1;
      }
    }
  }

  if (total == 0) {
    stderr.writeln('No coverage data found in $lcovPath');
    exit(2);
  }

  final ratio = covered / total;
  final percent = (ratio * 100).toStringAsFixed(2);
  stdout.writeln('Line coverage: $percent% ($covered / $total)');

  if (ratio + 1e-9 < threshold) {
    stderr.writeln('Coverage below threshold ${threshold * 100}%');
    exit(1);
  }

  stdout.writeln('Coverage meets threshold.');
}
