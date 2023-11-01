import 'dart:io';
import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../common/utils/shell/shel.utils.dart';
import '../../core/structure.dart';
import 'package:path/path.dart' as p;

import 'config_main_file.dart';

Future configMiniApp(String module, String path) async {
  Directory.current = path;

  // remove inessential folders
  await ShellUtils.removeFolder('linux');
  await ShellUtils.removeFolder('macos');
  await ShellUtils.removeFolder('windows');
  await ShellUtils.removeFolder('test');

  // add dependencies
  await PubspecUtils.addPathDependencies(module, path: '../');

  await PubspecUtils.addDependencies('build_runner', isDev: true, runPubGet: true);

  // config main file
  final pathFileMain = Structure.replaceAsExpected(
      path: '$path${p.separator}lib${p.separator}main.dart');
  await configMainFile(pathFileMain, module);

  LogService.success('Mini app $module created successfully!');
}
