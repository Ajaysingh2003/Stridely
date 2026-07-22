import 'dart:io';

void main() async {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final printRegex = RegExp(r'(?<!\w)(debugPrint|print)\s*\([\s\S]*?\);', multiLine: true);

  for (final file in files) {
    String content = await file.readAsString();
    bool changed = false;

    // Check if file contains rethrow. If not, just remove all prints.
    if (!content.contains('rethrow;')) {
      if (printRegex.hasMatch(content)) {
        content = content.replaceAll(printRegex, '');
        changed = true;
      }
    } else {
      // More complex: try to find prints. If a print is close to a rethrow, keep it.
      // A naive approach: split by block, or just don't touch files with rethrow for now and manually check them.
      // Wait, let's see which files have rethrow!
    }

    if (changed) {
      await file.writeAsString(content);
      print('Updated ${file.path}');
    }
  }
}
