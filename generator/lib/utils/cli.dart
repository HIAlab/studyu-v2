import 'dart:io';

const copierBin = 'copier';
const copierTemplate = 'gh:hpi-studyu/copier-studyu';

const nbConvertBin = 'conda run jupyter nbconvert';

class CliService {
  static Future<bool> runProcess(
      String executable, List<String> arguments) async {
    final result = await Process.run(
      executable,
      arguments,
      runInShell: true,
    );
    print('stdout of command: ${result.stdout}');
    if (result.exitCode != 0) {
      print('stderr of command: ${result.stderr}');
      return false;
    } else {
      return true;
    }
  }

  static Future<void> generateCopierProject(
      String projectPath, String studyTitle) async {
    await runProcess(copierBin, [
      copierTemplate,
      projectPath,
      '--data',
      'study_title=$studyTitle',
    ]);
  }

  static Future<void> generateNotebookHtml(String filePath) async {
    await runProcess(nbConvertBin, [
      '--execute',
      '--to',
      'html',
      filePath,
      '--no-prompt',
      '--template',
      'template/',
    ]);
  }
}